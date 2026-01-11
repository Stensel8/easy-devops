using System;
using System.Net.NetworkInformation;
using System.Text;
using System.Threading;

static class MyColors
{
    // Using standard ConsoleColor values to approximate your desired colors:
    public const ConsoleColor Teal = ConsoleColor.Cyan;
    public const ConsoleColor BrightGreen = ConsoleColor.Green;   // Bright green
    public const ConsoleColor BrightYellow = ConsoleColor.Yellow; // Bright yellow
    public const ConsoleColor White = ConsoleColor.White;         // White
}

class Program
{
    static void Main(string[] args)
    {
        // Ensure the console uses UTF8 encoding.
        Console.OutputEncoding = Encoding.UTF8;

        while (true)
        {
            Console.Clear();

            PrintAsciiArtLogo();
            PrintRainbowText("Case Study ITM");
            PrintRainbowText("Developed by Sten Tijhuis");
            PrintRainbowText("Student ID: 550600");
            PrintRainbowText("Version V1.1.2");

            WriteColoredLine("\nWelcome to Easy-DevOps!", MyColors.BrightGreen);
            WriteColoredLine("\nITM-550600\n", MyColors.White);

            string time = DateTime.Now.ToString("HH:mm");
            WriteColoredLine($"Current Time: {time}", MyColors.BrightGreen);

            DisplayPing();

            // Refresh every 10 seconds
            Thread.Sleep(10000);
        }
    }

    static void WriteColoredLine(string text, ConsoleColor color)
    {
        Console.ForegroundColor = color;
        Console.WriteLine(text);
        Console.ResetColor();
    }

    static void DisplayPing()
    {
        string[] domains = { "mooindag.nl", "stentijhuis.nl", "google.com", "github.com", "microsoft.com", "www.saxion.nl", "uptime.stensel.cloud" };

        WriteColoredLine("\nLive Response Times:", MyColors.BrightYellow);

        foreach (string domain in domains)
        {
            try
            {
                using (Ping ping = new Ping())
                {
                    PingReply reply = ping.Send(domain);
                    if (reply.Status == IPStatus.Success)
                    {
                        WriteColoredLine($"  {domain}: {reply.RoundtripTime} ms", MyColors.BrightGreen);
                    }
                    else
                    {
                        WriteColoredLine($"  {domain}: Unreachable", ConsoleColor.Red);
                    }
                }
            }
            catch (Exception ex)
            {
                WriteColoredLine($"  {domain}: Error ({ex.Message})", ConsoleColor.Red);
            }
        }
    }

    static void PrintRainbowText(string text)
    {
        // Approximate a rainbow using available ConsoleColors.
        ConsoleColor[] rainbowColors = {
            ConsoleColor.Red,
            ConsoleColor.Magenta,
            ConsoleColor.Yellow,
            ConsoleColor.Green,
            ConsoleColor.Cyan,
            ConsoleColor.Blue,
            ConsoleColor.DarkMagenta
        };

        int colorIndex = 0;
        foreach (char c in text)
        {
            Console.ForegroundColor = rainbowColors[colorIndex];
            Console.Write(c);
            colorIndex = (colorIndex + 1) % rainbowColors.Length;
        }
        Console.ResetColor();
        Console.WriteLine();
    }

    static void PrintAsciiArtLogo()
    {
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
            WriteColoredLine(line, MyColors.Teal);
        }
        Console.WriteLine();
    }
}
