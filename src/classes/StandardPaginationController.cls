public class StandardPaginationController {
    public ApexPages.StandardSetController standardSetController {get; private set;}

    public StandardPaginationController (ApexPages.StandardSetController standardSetController) {
        this.standardSetController = standardSetController;
    }

    public StandardPaginationController getPaginationController () {
        return this;
    }

    public Integer getPageCount() {
        Integer resultSize = standardSetController.getResultSize();
        Integer pageSize = standardSetController.getPageSize();

        Integer oddRecordCount = Math.mod(resultSize, pageSize);
        return ((resultSize - oddRecordCount) / pageSize) + (oddRecordCount > 0 ? 1 : 0);
    }
}