using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NLog;

namespace RightsU.Audit.Entities.FrameworkClasses
{
    public static class Logging
    {
        public static void Debug(this ILogger logger, string message, Exception exception = null)
        {
            FilteredLog(logger, LogLevel.Debug, message, exception);
        }
        public static void Information(this ILogger logger, string message, Exception exception = null)
        {
            FilteredLog(logger, LogLevel.Info, message, exception);
        }
        public static void Warning(this ILogger logger, string message, Exception exception = null)
        {
            FilteredLog(logger, LogLevel.Warn, message, exception);
        }
        public static void Error(this ILogger logger, string message, Exception exception = null, string usercode = "", string request = "", string module = "")
        {
            FilteredLog(logger, LogLevel.Error, message, exception, usercode, request, module);
        }
        public static void Fatal(this ILogger logger, string message, Exception exception = null)
        {
            FilteredLog(logger, LogLevel.Fatal, message, exception);
        }
        public static void Trace(this ILogger logger, string message, Exception exception = null)
        {
            FilteredLog(logger, LogLevel.Trace, message, exception);
        }

        private static void FilteredLog(ILogger logger, LogLevel level, string message, Exception exception = null, string usercode = "", string request = "", string module = "")
        {
            //don't log thread abort exception
            if (exception is System.Threading.ThreadAbortException)
                return;

            if (logger.IsEnabled(level))
            {
                string fullMessage = (exception == null ? message : message + " " + exception.ToString());

                if (level == LogLevel.Debug)
                {
                    logger.Debug(fullMessage);
                }
                else if (level == LogLevel.Trace)
                {
                    logger.Trace(fullMessage);
                }
                else if (level == LogLevel.Info)
                {
                    logger.Info(fullMessage);
                }
                else if (level == LogLevel.Warn)
                {
                    logger.Warn(fullMessage);
                }
                else if (level == LogLevel.Error)
                {

                    string msg = LogInnerEx(logger, exception);
                    fullMessage = (msg == "" ? message : message + " " + msg);

                    LogEventInfo theEvent = new LogEventInfo(LogLevel.Error, "", fullMessage);
                    theEvent.Properties["usercode"] = usercode;
                    theEvent.Properties["request"] = request;
                    theEvent.Properties["module"] = module;
                    logger.Error(theEvent);

                }
                else if (level == LogLevel.Fatal)
                {
                    logger.Fatal(fullMessage);
                    LogInnerEx(logger, exception);
                }
            }
        }

        private static string LogInnerEx(ILogger logger, Exception exception)
        {
            string msg = "";
            if (exception != null)
            {
                msg = exception.ToString();
                var inEx = exception.InnerException;
                while (inEx != null)
                {
                    // logger.Error("ínner ex:" + inEx.ToString());
                    msg = inEx.ToString();
                    inEx = inEx.InnerException;
                }
            }
            return msg;
        }
    }
}
