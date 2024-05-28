using System;
using System.Text.RegularExpressions;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;

	/// <summary>
	/// A class for providing some useful string handling utilities. You do not need to instantiate this
	/// object.
	/// </summary>
	public class NumericUtils
	{
		/// <summary>
		/// Constructor.
		/// </summary>
		public NumericUtils()
		{
		}

		// Function to test for Positive Integers.

		public static bool IsNaturalNumber(String strNumber)
		{
			Regex objNotNaturalPattern=new Regex("[^0-9]");
			Regex objNaturalPattern=new Regex("0*[1-9][0-9]*");

			return  !objNotNaturalPattern.IsMatch(strNumber) &&
				objNaturalPattern.IsMatch(strNumber);
		}

		// Function to test for Positive Integers with zero inclusive

		public static bool IsWholeNumber(string strNumber)
		{
			Regex objNotWholePattern=new Regex("[^0-9]");

			return !objNotWholePattern.IsMatch(strNumber);
		}

		// Function to Test for Integers both Positive & Negative

		public static bool IsInteger(string strNumber)
		{
			Regex objNotIntPattern=new Regex("[^0-9-]");
			Regex objIntPattern=new Regex("^-[0-9]+$|^[0-9]+$");

			return  !objNotIntPattern.IsMatch(strNumber) &&
				objIntPattern.IsMatch(strNumber);
		}

		// Function to Test for Positive Number both Integer & Real

		public static bool IsPositiveNumber(string strNumber)
		{
			Regex objNotPositivePattern=new Regex("[^0-9.]");
			Regex objPositivePattern=new Regex("^[.][0-9]+$|[0-9]*[.]*[0-9]+$");
			Regex objTwoDotPattern=new Regex("[0-9]*[.][0-9]*[.][0-9]*");

			return !objNotPositivePattern.IsMatch(strNumber) &&
				objPositivePattern.IsMatch(strNumber)  &&
				!objTwoDotPattern.IsMatch(strNumber);
		}

		// Function to test whether the string is valid number or not
		public static bool IsNumber(string strNumber)
		{
			Regex objNotNumberPattern=new Regex("[^0-9.-]");
			Regex objTwoDotPattern=new Regex("[0-9]*[.][0-9]*[.][0-9]*");
			Regex objTwoMinusPattern=new Regex("[0-9]*[-][0-9]*[-][0-9]*");
			String strValidRealPattern="^([-]|[.]|[-.]|[0-9])[0-9]*[.]*[0-9]+$";
			String strValidIntegerPattern="^([-]|[0-9])[0-9]*$";
			Regex objNumberPattern =new Regex("(" + strValidRealPattern +")|(" + strValidIntegerPattern + ")");

			return !objNotNumberPattern.IsMatch(strNumber) &&
				!objTwoDotPattern.IsMatch(strNumber) &&
				!objTwoMinusPattern.IsMatch(strNumber) &&
				objNumberPattern.IsMatch(strNumber);
		}

		// Function To test for Alphabets.

		public  static bool IsAlpha(string strToCheck)
		{
			Regex objAlphaPattern=new Regex("[^a-zA-Z]");

			return !objAlphaPattern.IsMatch(strToCheck);
		}

		// Function to Check for AlphaNumeric.

		public  static bool IsAlphaNumeric(string strToCheck)
		{
			Regex objAlphaNumericPattern=new Regex("[^a-zA-Z0-9]");

			return !objAlphaNumericPattern.IsMatch(strToCheck);    
		}

        
        //Logic of starRound function changed to Normal Round: AUG-07-2007  : Zeeshan
        //public static double starRound(double oldVal)
        //{
        //    string oldval = Convert.ToString(oldVal);
        //    string lastnum, seconlastnum, otherstring;
        //    if (oldval.IndexOf(".") != -1)
        //    {
        //        string decString = (oldval.Split('.'))[1];
        //        while (decString.Length > Convert.ToInt32(ConfigurationManager.AppSettings["DecimalPlace"].ToString()))
        //        {
        //            lastnum = decString.Substring(decString.Length - 1, 1);
        //            seconlastnum = decString.Substring(decString.Length - 2, 1);
        //            otherstring = decString.Substring(0, decString.Length - 2);

        //            if (decString.Length == 3 && decString.Substring(0, 2) == "99" && Convert.ToInt32(decString.Substring(decString.Length - 1, 1)) >= 6)
        //            {
        //                decString = "+1";
        //            }
        //            else if (decString.Length == 3 && decString.Substring(decString.Length - 2, 2) == "99")
        //            {
        //                decString = Convert.ToString(Convert.ToInt32(decString.Substring(0, 3)) + 1);
        //            }
        //            else if (Convert.ToInt32(decString.Substring(decString.Length - 1, 1)) >= 6)
        //            {
        //                if (Convert.ToInt32(seconlastnum) == 9)
        //                    decString = otherstring + "9";
        //                else
        //                    decString = otherstring + Convert.ToString((Convert.ToInt32(seconlastnum)) + 1);
        //            }
        //            else
        //                decString = decString.Substring(0, decString.Length - 1);
        //        }
        //        if (decString == "+1")
        //            return Convert.ToDouble((oldval.Split('.'))[0]) + 1;
        //        else
        //            return Convert.ToDouble((oldval.Split('.'))[0] + "." + decString);
        //    }
        //    else
        //    {
        //        return oldVal;
        //    }
        //}
        //public static double starRound_old(double oldVal)
        //{
        //    double newVal = 0;
        //    newVal = oldVal;
        //    double offset = 0;
        //    //new codition
        //    offset = oldVal * 1000;
        //    //old condition
        //    //offset =newVal * 1000;
        //    offset = offset % 10;
        //    if (offset >= 6)
        //        newVal = Math.Round((newVal), 2);
        //    else
        //    {
        //        //newVal = newVal - (0.001 * offset);
        //        if (newVal.ToString().IndexOf(".") != -1)
        //        {
        //            if (newVal.ToString().IndexOf(".") + 3 > newVal.ToString().Length)
        //                newVal = Convert.ToDouble(newVal.ToString().Substring(0, newVal.ToString().Length));
        //            else
        //                newVal = Convert.ToDouble(newVal.ToString().Substring(0, newVal.ToString().IndexOf(".") + 3));
        //        }
        //        else
        //            newVal = newVal;
        //    }
        //    return newVal;
        //}

        public static double starRound(double oldVal) {
            return Math.Round(oldVal, 2);
        }

	}

