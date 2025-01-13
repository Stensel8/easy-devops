// See https://aka.ms/new-console-template for more information

using System.Diagnostics;
using System.Net.NetworkInformation;

class Program
{
    static void Main(string[] args)
    {
        // Start a loop for the live clock and ping updates
        while (true)
        {
            Console.Clear();
            Console.WriteLine("Welcome to Easy-DevOps!");
            Console.WriteLine("\n ITM-550600\n");

            // Display the current time
            Console.WriteLine("Current Time: " + DateTime.Now);

            // Ping well-known domains and show their response times
            string[] domains = {"mooindag.nl", "stentijhuis.nl", "google.com", "github.com", "microsoft.com"};
            Console.WriteLine("\nLive Response Times:");

            foreach (string domain in domains)
            {
                try
                {
                    Ping ping = new Ping();
                    PingReply reply = ping.Send(domain);

                    if (reply.Status == IPStatus.Success)
                    {
                        Console.WriteLine($"  {domain}: {reply.RoundtripTime} ms");
                    }
                    else
                    {
                        Console.WriteLine($"  {domain}: Unreachable");
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"  {domain}: Error ({ex.Message})");
                }
            }
            // Wait for 5 seconds before refreshing
            Thread.Sleep(5000);
        }
    }
}
