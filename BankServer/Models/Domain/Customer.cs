using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Identity;

namespace BankServer.Models.Domain
{
    public class Customer : IdentityUser
    {
        public string FirstName { get; set; }   
        public string LastName { get; set; }
        public string IBAN { get; set; }
        public int AccountNumber { get; set; }
     
    }
}
