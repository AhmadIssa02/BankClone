using BankServer.Models.Domain.BankServer.Models.Domain;
using static BankServer.Repositories.Interfaces.IGenericRepository;

namespace BankServer.Repositories.Interfaces
{

    public interface IUnitOfWork : IDisposable
    {
        IGenericRepository<AccountBalance> AccountBalanceRepository { get; }
        IGenericRepository<Transaction> TransactionRepository { get; }

        Task Save();
    }

}
