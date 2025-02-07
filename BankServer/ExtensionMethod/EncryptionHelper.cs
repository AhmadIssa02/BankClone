using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using Microsoft.Extensions.Configuration;

public class EncryptionHelper
{
    private static string Key;

    static EncryptionHelper()
    {
        var configuration = new ConfigurationBuilder()
            .AddJsonFile("appsettings.json")
            .Build();
        Key = configuration["EncryptionSettings:Key"];
    }

    public static string Decrypt(string encryptedText)
    {
        try
        {
            var parts = encryptedText.Split(':');
            if (parts.Length != 2)
            {
                throw new ArgumentException("Invalid encrypted text format.");
            }

            byte[] iv = Convert.FromBase64String(parts[0]);  
            byte[] buffer = Convert.FromBase64String(parts[1]); 
            using (Aes aes = Aes.Create())
            {
                aes.Key = Encoding.UTF8.GetBytes(Key);
                aes.IV = iv;  
                aes.Mode = CipherMode.CBC;
                aes.Padding = PaddingMode.PKCS7;

                using (ICryptoTransform decryptor = aes.CreateDecryptor(aes.Key, aes.IV))
                using (MemoryStream ms = new MemoryStream(buffer))
                using (CryptoStream cs = new CryptoStream(ms, decryptor, CryptoStreamMode.Read))
                using (StreamReader reader = new StreamReader(cs))
                {
                    return reader.ReadToEnd(); 
                }
            }
        }
        catch (Exception ex)
        {
            throw new Exception("Decryption failed.", ex);
        }
    }
}
