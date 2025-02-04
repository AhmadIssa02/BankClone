namespace BankServer.Repositories.Interfaces
{
   using BankServer.Models.Domain;
   using BankServer.Models.DTOs;

   public interface ICustomerRepository
   {
      Task<Customer> getCustomerByEmail(string email);
      Task<IList<Customer>> getAllCutsomers();
      Task<bool> addCustomer(CustomerDto customerdto);
      Task<bool> editCustomer(CustomerDto customerdto);
      Task<bool> deleteCustomer(string email);
   }
}
