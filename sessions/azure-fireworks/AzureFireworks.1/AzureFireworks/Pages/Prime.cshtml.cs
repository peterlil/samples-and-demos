using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace AzureFireworks.Pages
{
    public class PrimeModel : PageModel
    {
        public string Audience { get { return "Volvo";  } }
        public int Prime {  get { return AzureFireworks.Model.Prime.RandomPrime(); } }
        public void OnGet()
        {
        }
    }
}
