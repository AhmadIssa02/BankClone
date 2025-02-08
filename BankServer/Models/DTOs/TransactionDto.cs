namespace BankServer.Models.DTOs
{
    public class TransactionDto
    {
        public int SenderAccountNumber { get; set; }
        public int ReceiverAccountNumber { get; set; }
        public decimal Amount { get; set; }
        public string Description { get; set; }
    }
 

}
