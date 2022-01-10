using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Notification_Service
{
    public class Error
    {
        public static void LogErr(string moduleName, string methodName, string msg, string path)
        {
            StreamWriter sw;
            //if (!File.Exists(System.Windows.Forms.Application.StartupPath + "\\LogErr.txt"))
            if (!File.Exists(path + "\\LogErr.txt"))
            {
                sw = File.CreateText(path + "\\LogErr.txt");
                //sw.WriteLine(DateTime.Now.ToString("dd-MMM-yyyy"));
                sw.Close();
            }

            sw = File.AppendText(path + "\\LogErr.txt");
            sw.WriteLine("");
            sw.WriteLine("-------------------------------------------------");
            sw.WriteLine(DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + "    UTO INVOICING");
            sw.Close();

            sw = File.AppendText(path + "\\LogErr.txt");
            sw.WriteLine(moduleName + "    " + methodName);
            sw.WriteLine(msg);
            sw.Close();
            //System.Windows.Forms.MessageBox.Show("Error found:" + msg);
        }

        public static void LogErr(string moduleName, string methodName, string msg, string path, string FileName)
        {
            StreamWriter sw;
            if (!File.Exists(path + "\\LogErr.txt"))
            {
                sw = File.CreateText(path + "\\LogErr.txt");
                sw.Close();
            }

            sw = File.AppendText(path + "\\LogErr.txt");
            sw.WriteLine("");
            sw.WriteLine("********************" + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + "********************");
            sw.Close();

            sw = File.AppendText(path + "\\LogErr.txt");
            sw.WriteLine("MODULE NAME   :-----   " + moduleName);
            sw.WriteLine("METHOD NAME   :-----   " + methodName);
            sw.WriteLine("FILE NAME     :-----   " + FileName);
            sw.WriteLine("ERROR MESSAGE :-----   " + msg);
            sw.WriteLine("********************" + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + "********************");
            sw.Close();

        }

        public static void Log_It(string msg, string path, string FileName)
        {
            StreamWriter sw;
            if (!File.Exists(path + "\\Log.txt"))
            {
                sw = File.CreateText(path + "\\Log.txt");
                sw.Close();
            }

            sw = File.AppendText(path + "\\Log.txt");
            sw.WriteLine("FILE NAME     :-----   " + FileName);
            sw.WriteLine("ERROR MESSAGE :-----   " + msg);
            sw.WriteLine("********************" + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + "********************");
            sw.Close();

        }

        public static void WriteLog(string ex, bool includeTime = false, bool addSeperater = true)
        {
            try
            {
                string filename = System.Configuration.ConfigurationManager.AppSettings["LogPath"];
                string todayDt = System.DateTime.Now.ToString("dd-MM-yyyy");
                filename = filename + "\\" + todayDt + "Log.txt";
               // string filename = AppDomain.CurrentDomain.BaseDirectory.ToString() + "Log.txt";

                if (!File.Exists(filename))
                {
                    FileStream fs = new FileStream(filename, FileMode.Create);
                    fs.Dispose();
                    fs.Close();
                }
                StreamWriter w = File.AppendText(filename);
                Log(ex, w, includeTime, addSeperater);
                w.Dispose();
                w.Close();
                GC.Collect();
            }
            catch (Exception e)
            {
                Console.Out.WriteLine("Error writing error log");
                Console.Out.WriteLine(e.Message);
            }
        }

        public static void WriteLog_Conditional(string ex, bool includeTime = false, bool addSeperater = false)
        {
            try
            {
                //if (System.Configuration.ConfigurationSettings.AppSettings["ShowLog"] == "N")
                //    return;

                string filename = System.Configuration.ConfigurationManager.AppSettings["LogPath"];
                string todayDt = System.DateTime.Now.ToString("dd-MM-yyyy");
                filename = filename + "\\" + todayDt + "Log.txt";

               // string filename = AppDomain.CurrentDomain.BaseDirectory.ToString() + "Log.txt";

                if (!File.Exists(filename))
                {
                    FileStream fs = new FileStream(filename, FileMode.Create);
                    fs.Dispose();
                    fs.Close();
                }
                StreamWriter w = File.AppendText(filename);
                Log(ex, w, includeTime, addSeperater);
                w.Dispose();
                w.Close();
                GC.Collect();
            }
            catch (Exception e)
            {
                Console.Out.WriteLine("Error writing error log");
                Console.Out.WriteLine(e.Message);
            }
        }

        public static void Log(String logMessage, StreamWriter w, bool includeTime, bool addSeperater)
        {
            try
            {
                if (includeTime)
                {
                    w.WriteLine("{0} {1}", DateTime.Now.ToLongTimeString(), DateTime.Now.ToLongDateString());
                    w.WriteLine("---------------------------------------------------------------------------");
                }
                w.WriteLine("  :{0}", logMessage);
                if (addSeperater)
                    w.WriteLine("===========================================================================");
                w.Flush();
            }
            catch (Exception e)
            {
                Console.Out.WriteLine("Error writing log");
                Console.Out.WriteLine(e.Message);
            }
        }
    }
}
