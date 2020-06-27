using IBM.WMQ;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMQService
{
    public class MQTest
    {
        MQQueueManager queueManager;
        MQQueue queue;
        MQMessage queueMessage;
        MQPutMessageOptions queuePutMessageOptions;
        MQGetMessageOptions queueGetMessageOptions;

        static string QueueName;
        static string QueueManagerName;
        static string ChannelInfo;
        string channelName;
        string transportType;
        string connectionName;
        string message;

        public MQTest()
        {
            //Initialisation
            /*
            QueueManagerName = "QM_TEST";
            QueueName = " QM_TEST.LOCAL.ONE";
            ChannelInfo = "QM._TEST.SVRCONN/TCP/psingh(1421)";
            */
        }
        public string ConnectMQ(string strQueueManagerName, string strQueueName, string strChannelInfo)
        {
            //
            QueueManagerName = strQueueManagerName;
            QueueName = strQueueName;
            ChannelInfo = strChannelInfo;
            //
            char[] separator = { '/' };
            string[] ChannelParams;
            ChannelParams = ChannelInfo.Split(separator);
            channelName = ChannelParams[0];
            transportType = ChannelParams[1];
            connectionName = ChannelParams[2];
            String strReturn = "";
            try
            {
                queueManager = new MQQueueManager(QueueManagerName,
                channelName, connectionName);
                strReturn = "Connected Successfully";
            }
            catch (MQException exp)
            {

                strReturn = "Exception: " + exp.Message;
            }
            return strReturn;
        }

        public string WriteMsg(string strInputMsg)
        {
            string strReturn = "";
            try
            {
                queue = queueManager.AccessQueue(QueueName, MQC.MQOO_OUTPUT + MQC.MQOO_FAIL_IF_QUIESCING);
                message = strInputMsg;
                queueMessage = new MQMessage();
                queueMessage.CharacterSet = 1208;
                queueMessage.WriteString(message);
                queueMessage.Format = MQC.MQFMT_STRING;
                queuePutMessageOptions = new MQPutMessageOptions();
                queue.Put(queueMessage, queuePutMessageOptions);
                strReturn = "Message sent to the queue successfully";
            }
            catch (MQException MQexp)
            {
                strReturn = "Exception: " + MQexp.Message;
            }
            catch (Exception exp)
            {
                strReturn = "Exception: " + exp.Message;
            }
            return strReturn;
        }

        public string ReadMsg()
        {
            String strReturn = "";
            try
            {
                queue = queueManager.AccessQueue(QueueName, MQC.MQOO_INPUT_AS_Q_DEF + MQC.MQOO_FAIL_IF_QUIESCING);
                queueMessage = new MQMessage();
                queueMessage.CharacterSet = 1208;
                queueMessage.Format = MQC.MQFMT_STRING;
                queueGetMessageOptions = new MQGetMessageOptions();
                queue.Get(queueMessage, queueGetMessageOptions);
                strReturn = queueMessage.ReadString(queueMessage.MessageLength);
            }
            catch (MQException MQexp)
            {
                strReturn = "Exception : " + MQexp.Message;
            }
            catch (Exception exp)
            {
                strReturn = "Exception: " + exp.Message;
            }
            return strReturn;
        }
    }

}
