using AutoMapper;
using BankServer.Models.DTOs;
using BankServer.Repositories.Interfaces;
using BankServer.Models.Domain;


namespace BankServer.Services.Implementations
{
   

    public class CustomerService : ICustomerService
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly IMapper _mapper;

        public CustomerService(ICustomerRepository customerRepository, IMapper mapper)
        {
            _customerRepository = customerRepository;
            _mapper = mapper;
        }

        public async Task<bool> AddCustomerAsync(CustomerDto customerDto)
        {

            var accountNumber = GenerateRandomAccountNumber();
            var iban = GenerateRandomIBAN(accountNumber);

            var customer = _mapper.Map<Customer>(customerDto);
            customer.AccountNumber = accountNumber;
            customer.IBAN = iban;
            customer.PasswordHash = customerDto.Password;

            return await _customerRepository.addCustomer(customer);
        }

        public async Task<bool> EditCustomerAsync(CustomerDto customerDto)
        {
            var customer = _mapper.Map<Customer>(customerDto);
            customer.PasswordHash = customerDto.Password;
            customer.FirstName = customerDto.FirstName;
            customer.LastName = customerDto.LastName;


            return await _customerRepository.editCustomer(customer);
        }

        public async Task<bool> DeleteCustomerAsync(string email)
        {
            return await _customerRepository.deleteCustomer(email);
        }

        public async Task<IList<Customer>> GetAllCustomersAsync()
        {
            return await _customerRepository.getAllCutsomers();
        }

        public async Task<Customer> GetCustomerByEmailAsync(string email)
        {
            return await _customerRepository.getCustomerByEmail(email);
        }

        public async Task<bool> ChangePasswordAsync(EditCustomerPasswordDto editCustomerDto)
        {
            var customer = _mapper.Map<Customer>(editCustomerDto);
            customer.PasswordHash = editCustomerDto.Password;

            return await _customerRepository.changePassword(customer);
        }

        private int GenerateRandomAccountNumber()
        {
            var random = new Random();
            return random.Next(100000000, 999999999);
        }

        private string GenerateRandomIBAN(int accountNumber)
        {
            var random = new Random();
            // Generate random IBAN in the format: JOXXEFBKXXXXXXXX
            var iban = "JO" + random.Next(10, 99).ToString() + "EFBK" + random.Next(100000000, 999999999).ToString();
            iban += accountNumber.ToString();
            return iban;
        }
      
    }
}
