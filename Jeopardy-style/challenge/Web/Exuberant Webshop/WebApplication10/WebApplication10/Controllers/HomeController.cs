using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using WebApplication10.Models;

namespace WebApplication10.Controllers
{
    public class HomeController : Controller
    {
        static int price = 0;
        List<string> sentences = new List<string> { "You gotta ask yourself, do I feel lucky, well do ya punk?", "Looking for a flag? - Not this time my friend :)", "The bread always falls buttered side down", "Some Guys Have All The Luck", "Freeloader all the way" };
        Random r = new Random();

        public IActionResult Index()
        {    
            return View();
        }
        [HttpPost]
        public IActionResult Index(int amount)
        {
            const int pricePerItem = 100;
            price = pricePerItem * amount;

            return View((object)price);
        }

        public IActionResult About()
        {
            int index = r.Next(4);
             index = r.Next(4);
            if (price < 0)
                ViewData["Message"] = "EAL{It's_YA_lucky_NITE}"; 
            else
                ViewData["Message"] = sentences[index];
            price = 0;
            return View();
        }
        
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
