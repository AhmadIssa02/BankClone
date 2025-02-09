namespace BankServer.Repositories.Interfaces
{
   using BankServer.Models.Domain;

   public interface ICustomerRepository
   {
        Task<Customer> GetCustomerByAccountNumber(int accountNumber);


        Task<Customer> getCustomerByEmail(string email);
      Task<IList<Customer>> getAllCutsomers();
      Task<bool> addCustomer(Customer customerd);
      Task<bool> editCustomer(Customer customer);
      Task<bool> deleteCustomer(string email);
      Task<bool> changePassword(Customer customer);
   }
}
