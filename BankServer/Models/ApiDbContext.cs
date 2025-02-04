using BankServer.Models.Domain;
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
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Customer>()
                .HasIndex(c => c.Email)
                .IsUnique();
        }
    }
}
