using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AdoWebApp.Model
{
    public static class Prime
    {
        public static int RandomPrime()
        {
            Random rand = new Random(DateTime.Now.Millisecond);
            int nth = rand.Next(100000, 200000);
            int count = 0;
            int i = 0;

            
            while (count < nth)
            {
                if (PrimeTool.IsPrime(i++)) count++;
            }

            // Bug #1
            // Make sure the prime number is greater than zero
            if (count > 0)
            {
                throw new Exception("Abort, a prime cannot be zero (0)");
            }


            // Bug #2
            int devider = rand.Next(1, 5) - 1;
            int res = count / devider;

            return count;

        }


    }

    public static class PrimeTool
    {
        public static bool IsPrime(int candidate)
        {
            // Test whether the parameter is a prime number.
            if ((candidate & 1) == 0)
            {
                if (candidate == 2)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            // Note:
            // ... This version was changed to test the square.
            // ... Original version tested against the square root.
            // ... Also we exclude 1 at the end.
            for (int i = 3; (i * i) <= candidate; i += 2)
            {
                if ((candidate % i) == 0)
                {
                    return false;
                }
            }
            return candidate != 1;
        }
    }
}
