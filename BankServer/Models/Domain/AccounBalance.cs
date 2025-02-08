namespace BankServer.Models.Domain
{
    using System.ComponentModel.DataAnnotations;
    namespace BankServer.Models.Domain
    {
        public class AccountBalance
        {
            [Key]
            public int AccountBalanceId { get; set; }
            [Required]
            public string CustomerId { get; set; }

            [Required]
            public decimal Balance { get; set; }
            public virtual Customer Customer { get; set; }
        }
    }

}
