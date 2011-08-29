public class AccountListController extends DynamicListController {
    public AccountListController() {
        super('select Id, CreatedDate, Name from Account');
        pageSize = 10;
    }

    // cast the resultset
    public List<Account> getAccounts() {
        return (List<Account>) getRecords();
    }
}
