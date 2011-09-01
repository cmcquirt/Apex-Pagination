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

    // testing and deployment
    static testmethod void testStandardPaginationController() {
        Integer numAccounts = 200;
        setup(numAccounts);

        ApexPages.StandardSetController standardSetController = new ApexPages.StandardSetController(Database.getQueryLocator([select Id, Name, CreatedDate from Account]));
        StandardPaginationController pController = new StandardPaginationController(standardSetController);
        Integer pageCount = pController.getPageCount();
        StandardPaginationController pc = pController.getPaginationController();
    }

    public static void setup(Integer numAccounts) {
        // create numAccounts Account records
        List<Account> accounts = new List<Account>();
        for (Integer i=0; i<numAccounts; i++) {
            Account account = new Account(Name = 'TEST ' + i);
            accounts.add(account);
        }
        if (!accounts.isEmpty()) insert accounts;
    }
}