using System.ComponentModel.DataAnnotations;
using BankServer.Models.Domain.BankServer.Models.Domain;
using Microsoft.AspNetCore.Identity;

namespace BankServer.Models.Domain
{
    public class Customer : IdentityUser
    {
        public string FirstName { get; set; }   
        public string LastName { get; set; }
        public string IBAN { get; set; }
        public int AccountNumber { get; set; }

        [Required]
        public DateTime DateCreated { get; set; } = DateTime.UtcNow;
        public virtual AccountBalance AccountBalance { get; set; }  
        public virtual ICollection<Transaction> Transactions { get; set; }  
    }

}
