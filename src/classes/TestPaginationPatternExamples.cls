@isTest
private class TestPaginationPatternExamples {
    public static void setup(Integer numAccounts) {
        // create numAccounts Account records
        List<Account> accounts = new List<Account>();
        for (Integer i=0; i<numAccounts; i++) {
            Account account = new Account(Name = 'TEST ' + i);
            accounts.add(account);
        }
        if (!accounts.isEmpty()) insert accounts;
    }

    static testmethod void testAccountListController() {
        // setup
        Integer numAccounts = 200;
        setup(numAccounts);

        // instantiate
        AccountListController accountList = new AccountListController();
        accountList.pageSize = 15;
        
        // search
        accountList.nameSearchFld = 'TEST%';
        accountList.search();

        Integer resultSize = accountList.getResultSize();
        Integer pageCount = accountList.getPageCount();
        System.Assert(resultSize >= numAccounts , 'We expect the result size to be at least ' + numAccounts + ' reflecting the number of accounts we created.');
        System.Assert(pageCount >= numAccounts/accountList.pageSize , 'We expect the page count to reflect the number of accounts we created divided by the page size.');

        // sort
        accountList.sortColumn = 'Name';
        accountList.sortAsc = true;
        accountList.sort(); 

        // pagination
        List<Account> accounts = accountList.getAccounts();
        accountList.first();
        accountList.next();
        accountList.previous();
        accountList.last();
        
        if (accountList.getHasPrevious()) accountList.first();

        if (accountList.getHasNext()) 
            accountList.setPageNumber(accountList.getPageNumber() + 1);

        if (accountList.getHasPrevious()) 
            accountList.setPageNumber(accountList.getPageNumber() - 1);

        Boolean renderResults = accountList.getRenderResults();
        
        // transactional
        accountList.save();
        accountList.cancel();
        
        // pagination component
        DynamicListController pController = accountList.getController();
    }
}
