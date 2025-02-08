namespace BankServer.Models.Domain
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    namespace BankServer.Models.Domain
    {
        public class Transaction
        {
            [Key]
            public int TransactionId { get; set; }
            
            [Required]
            [ForeignKey("Sender")]
            public string SenderCustomerId { get; set; }

            [Required]
            [ForeignKey("Receiver")]
            public string ReceiverCustomerId { get; set; }

            [Required]
            public decimal Amount { get; set; }

            [Required]
            public DateTime TransactionDate { get; set; }

            public string Description { get; set; }

            public virtual Customer Sender { get; set; }
            public virtual Customer Receiver { get; set; }
        }
    }

}
