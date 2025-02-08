using BankServer.Models.Domain;
using BankServer.Models.Domain.BankServer.Models.Domain;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace BankServer.Models
{
    public class ApiDbContext : IdentityDbContext<Customer>
    {
        public ApiDbContext(DbContextOptions<ApiDbContext> options) : base(options) { 
        
        }
        public DbSet<Users> Users { get; set; }
        public DbSet<Customer> Customers { get; set; }
        public DbSet <AccountBalance> AccountBalances { get; set; }
        public DbSet <Transaction> Transactions { get; set; }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Customer>()
                .HasIndex(c => c.Email)
                .IsUnique();

             modelBuilder.Entity<AccountBalance>()
             .HasOne(ab => ab.Customer)
             .WithOne(c => c.AccountBalance)
             .HasForeignKey<AccountBalance>(ab => ab.CustomerId);

            modelBuilder.Entity<Transaction>()
            .HasOne(t => t.Sender)
            .WithMany()
            .HasForeignKey(t => t.SenderCustomerId)
            .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Transaction>()
            .HasOne(t => t.Receiver)
            .WithMany()
            .HasForeignKey(t => t.ReceiverCustomerId)
            .OnDelete(DeleteBehavior.Restrict);
        }
    }
}
