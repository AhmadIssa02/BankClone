using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BankServer.Migrations
{
    /// <inheritdoc />
    public partial class extendingTheCustomer : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Transactions_AspNetUsers_ReceiverCustomerId",
                table: "Transactions");

            migrationBuilder.DropForeignKey(
                name: "FK_Transactions_AspNetUsers_SenderCustomerId",
                table: "Transactions");

            migrationBuilder.DropIndex(
                name: "IX_AccountBalances_CustomerId",
                table: "AccountBalances");

            migrationBuilder.AddColumn<string>(
                name: "CustomerId",
                table: "Transactions",
                type: "TEXT",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_CustomerId",
                table: "Transactions",
                column: "CustomerId");

            migrationBuilder.CreateIndex(
                name: "IX_AccountBalances_CustomerId",
                table: "AccountBalances",
                column: "CustomerId",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Transactions_AspNetUsers_CustomerId",
                table: "Transactions",
                column: "CustomerId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Transactions_AspNetUsers_ReceiverCustomerId",
                table: "Transactions",
                column: "ReceiverCustomerId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Transactions_AspNetUsers_SenderCustomerId",
                table: "Transactions",
                column: "SenderCustomerId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Transactions_AspNetUsers_CustomerId",
                table: "Transactions");

            migrationBuilder.DropForeignKey(
                name: "FK_Transactions_AspNetUsers_ReceiverCustomerId",
                table: "Transactions");

            migrationBuilder.DropForeignKey(
                name: "FK_Transactions_AspNetUsers_SenderCustomerId",
                table: "Transactions");

            migrationBuilder.DropIndex(
                name: "IX_Transactions_CustomerId",
                table: "Transactions");

            migrationBuilder.DropIndex(
                name: "IX_AccountBalances_CustomerId",
                table: "AccountBalances");

            migrationBuilder.DropColumn(
                name: "CustomerId",
                table: "Transactions");

            migrationBuilder.CreateIndex(
                name: "IX_AccountBalances_CustomerId",
                table: "AccountBalances",
                column: "CustomerId");

            migrationBuilder.AddForeignKey(
                name: "FK_Transactions_AspNetUsers_ReceiverCustomerId",
                table: "Transactions",
                column: "ReceiverCustomerId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Transactions_AspNetUsers_SenderCustomerId",
                table: "Transactions",
                column: "SenderCustomerId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
