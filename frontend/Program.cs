using System.Net.NetworkInformation;
using System.Drawing;
using Console = Colorful.Console;

class Program
{
    static void Main(string[] args)
    {
        while (true)
        {
            Console.Clear();

            // Print ASCII art logo
            PrintAsciiArtLogo();

            // Print the banner
            PrintRainbowText("Case Study ITM");
            PrintRainbowText("Developed by Sten Tijhuis");
            PrintRainbowText("Student ID: 550600");
            PrintRainbowText("Version V1.0");

            Console.WriteLine("\nWelcome to Easy-DevOps!", Color.White);
            Console.WriteLine("\nITM-550600\n", Color.White);

            // Display the current time (hours and minutes only)
            string time = DateTime.Now.ToString("HH:mm");
            Console.WriteLine($"Current Time: {time}", Color.LightGreen);

            // Display ping results
            DisplayPing();

            // Refresh every 10 seconds
            Thread.Sleep(10000);
        }
    }

    static void DisplayPing()
    {
        string[] domains = { "mooindag.nl", "stentijhuis.nl", "google.com", "github.com", "microsoft.com", "www.saxion.nl" };

        Console.WriteLine("\nLive Response Times:", Color.Yellow);

        foreach (string domain in domains)
        {
            try
            {
                Ping ping = new Ping();
                PingReply reply = ping.Send(domain);

                if (reply.Status == IPStatus.Success)
                {
                    Console.WriteLine($"  {domain}: {reply.RoundtripTime} ms", Color.Cyan);
                }
                else
                {
                    Console.WriteLine($"  {domain}: Unreachable", Color.Red);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"  {domain}: Error ({ex.Message})", Color.Red);
            }
        }
    }

    static void PrintRainbowText(string text)
    {
        // Define smooth rainbow colors
        Color[] rainbowColors = {
            Color.Red, Color.OrangeRed, Color.Orange,
            Color.Yellow, Color.GreenYellow, Color.Green,
            Color.Blue, Color.Indigo, Color.Violet
        };

        int colorIndex = 0;
        foreach (char c in text)
        {
            // Print each character with a rainbow color
            Console.Write(c, rainbowColors[colorIndex]);
            colorIndex = (colorIndex + 1) % rainbowColors.Length;
        }

        Console.WriteLine(); // Move to the next line after the text
    }

    static void PrintAsciiArtLogo()
    {
        // ASCII art logo for "ITM CASE"
        string[] logoLines = {
            " __  .___________..___  ___.      ______     ___           _______. _______ ",
            "|  | |           ||   \\/   |     /      |   /   \\         /       ||   ____|",
            "|  | `---|  |----`|  \\  /  |    |  ,----'  /  ^  \\       |   (----`|  |__   ",
            "|  |     |  |     |  |\\/|  |    |  |      /  /_\\  \\       \\   \\    |   __|  ",
            "|  |     |  |     |  |  |  |    |  `----./  _____  \\  .----)   |   |  |____ ",
            "|__|     |__|     |__|  |__|     \\______/__/     \\__\\ |_______/    |_______|",
            "                                                                             "
        };

        foreach (string line in logoLines)
        {
            Console.WriteLine(line, Color.Cyan); // Use Cyan for the logo
        }

        Console.WriteLine(); // Add spacing after the logo
    }
}
