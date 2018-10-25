using System;
using System.Threading;

namespace console
{
    class Program
    {
        static void Main(string[] args)
        {
            DateTime now = DateTime.Now;
            string today = now.ToString("dd/MM/yyyy");
            int iteration = 0;

            Console.WriteLine("Hello World!");
            Console.WriteLine($"Today is {today}");
            Console.WriteLine("Starting Loop");

            while (iteration < 100) 
            {
                string time = DateTime.Now.ToString("h:mm:ss tt");
                Console.WriteLine($"T: {time}");
                Thread.Sleep(1000);
                iteration++;
            }
        }
    }
}
