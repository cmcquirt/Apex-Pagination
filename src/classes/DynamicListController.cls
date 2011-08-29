public virtual class DynamicListController {
    private ApexPages.StandardSetController controller;
    private String baseQuery;
    public String nameSearchFld {get; set;}

    //** constructor
    public DynamicListController(String baseQuery) {
        this.baseQuery = baseQuery;
        query();
    }

    //** query methods
    protected void query() {
        // construct the query string
        String queryString = baseQuery + ' ' + getWhereClause() + ' ' + getSortClause() + ' limit 10000';
        System.debug('queryString: ' + queryString);

        // save pageSize
        Integer pageSize = this.pageSize;

        // reboot standard set controller
        controller = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));

        // reset pageSize
        this.pageSize = pageSize;
    }

    //** search methods
    public PageReference search() {
        query();

        // return to same page
        return null;
    }

    // override to construct dynamic SOQL where clause 
    public virtual String getWhereClause() {
        if (nameSearchFld != null && nameSearchFld.trim() != '')
            return 'where Name like :nameSearchFld ';
        else return '';
    }

    //** sort methods
    public String sortColumn {
		get {
			if (sortColumn == null) sortColumn = '';
			return sortColumn;
		}
		set {
			if (sortColumn != value) sortAsc = false;
			sortColumn = value;
		}
    }

    public Boolean sortAsc {
    	get {
    		if (sortAsc == null) sortAsc = false;
    		return sortAsc;
    	} 
    	set;
    }

    public PageReference sort() {
        sortAsc = !sortAsc;

        query();

        // return to same page
        return null;
    }

    protected virtual String getSortClause() {
        if (sortColumn == '') return '';
        else return ' order by ' + sortColumn + (sortAsc ? ' asc ' : ' desc ') + ' nulls last';
    }

    //** pageable methods
    // get records on current page 
    protected List<SObject> getRecords() {
        return controller.getRecords();
    }

    public void first() {
        controller.first();
    }

    public void previous() {
        controller.previous();
    }

    public void next() {
        controller.next();
    }

    public void last() {
        controller.last();
    }

    public Boolean getHasPrevious() {
        return controller.getHasPrevious();
    }

    public Boolean getHasNext() {
        return controller.getHasNext();
    }

    public Integer getResultSize() {
        return controller.getResultSize();
    }

    public Integer getPageCount() {
        Integer resultSize = getResultSize();

        Integer oddRecordCount = Math.mod(resultSize, pageSize);
        return ((resultSize - oddRecordCount) / pageSize) + (oddRecordCount > 0 ? 1 : 0);
    }

    public Integer getPageNumber() {
        return controller.getPageNumber();
    }

    public void setPageNumber(Integer pageNumber) {
        controller.setPageNumber(pageNumber);
    }

    public Integer pageSize {
        get {
            if (controller != null) 
                pageSize = controller.getPageSize();
            else
                // default pagesize
                pageSize = 20; 

            return pageSize;
        }

        set {
            pageSize = value;
            controller.setPageSize(pageSize);
        }
    }

    public Boolean getRenderResults() {
        return (getResultSize() > 0);
    }

    //** update methods
    public virtual PageReference save() {
        return controller.save();
    }

    public virtual PageReference cancel() {
        return controller.cancel();
    }

    //** pass reference to dynamic paginator component 
    public DynamicListController getController () {
        return this;
    }
}
