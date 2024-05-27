using Azure.Identity;
using Microsoft.Graph;
using Microsoft.Graph.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UTO.Notification.Teams
{
    public class TeamsHelper
    {
        public static string WriteLog { get; private set; }

        public static GraphServiceClient GetGraphServiceClient(USPGetConfig objConfig)
        {
            var scopes = new[] { objConfig.scope };

            // using Azure.Identity;  
            var options = new TokenCredentialOptions
            {
                AuthorityHost = AzureAuthorityHosts.AzurePublicCloud
            };

            var userNamePasswordCredential = new UsernamePasswordCredential(objConfig.UserName, objConfig.Password, objConfig.TenantId, objConfig.ClientId, options);

            return new GraphServiceClient(userNamePasswordCredential, scopes);
        }

        public static Chat GetChatPayload(string FromAddress, string ToAddress, ChatType chatType)
        {
            Chat chatPayload = new Chat();
            chatPayload.Members = new List<ConversationMember>();

            try
            {
                if (chatType == ChatType.OneOnOne)
                {
                    chatPayload = new Chat
                    {
                        ChatType = ChatType.OneOnOne,
                        Members = new List<ConversationMember>
                        {
                            new AadUserConversationMember
                            {
                                OdataType = "#microsoft.graph.aadUserConversationMember",
                                Roles = new List<string>
                                {
                                    "owner",
                                },
                                AdditionalData = new Dictionary<string, object>
                                {
                                    {
                                        "user@odata.bind" , "https://graph.microsoft.com/v1.0/users('"+FromAddress+"')"
                                    }
                                }
                            },
                            new AadUserConversationMember
                            {
                                OdataType = "#microsoft.graph.aadUserConversationMember",
                                Roles = new List<string>
                                {
                                    "owner",
                                },
                                AdditionalData = new Dictionary<string, object>
                                {
                                    {
                                        "user@odata.bind" , "https://graph.microsoft.com/v1.0/users('"+ToAddress+"')"
                                    }
                                }
                            }
                        }
                    };
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return chatPayload;
        }

        public static async Task<ChatMessage> SendTeamNotification(string ToAddress, ChatType chatType, string MsgBody, USPGetConfig objConfig)
        {
            //try
            //{
                WriteLog = ConfigurationSettings.AppSettings["WriteLog"];

                if (Convert.ToBoolean(WriteLog))
                {
                    //LogService("Sending Email");
                    Error.WriteLog_Conditional("Config - " + JsonConvert.SerializeObject(objConfig));
                }
                                

                var graphClient = GetGraphServiceClient(objConfig);

                
                var chatPayload = GetChatPayload(objConfig.UserName, ToAddress, chatType);

                if (Convert.ToBoolean(WriteLog))
                {
                    //LogService("Sending Email");
                    Error.WriteLog_Conditional("ChatPayload - " + JsonConvert.SerializeObject(chatPayload));
                }

                var objChat = await graphClient.Chats.PostAsync(chatPayload);

                if (Convert.ToBoolean(WriteLog))
                {
                    //LogService("Sending Email");
                    Error.WriteLog_Conditional("ChatResponse - " + JsonConvert.SerializeObject(objChat));
                }

                var requestBodyMessage = new ChatMessage
                {
                    Body = new ItemBody
                    {
                        ContentType = BodyType.Html,
                        Content = MsgBody,
                    },
                };

                var chatMessage = await graphClient.Chats[objChat.Id].Messages.PostAsync(requestBodyMessage);

                if (Convert.ToBoolean(WriteLog))
                {
                    //LogService("Sending Email");
                    Error.WriteLog_Conditional("ChatMessageResponse - " + JsonConvert.SerializeObject(chatMessage));
                }

                return chatMessage;
            //}
            //catch (ServiceException ex)
            //{
            //    //if (Convert.ToBoolean(WriteLog))
            //    //{
            //    //    //LogService("Sending Email");
            //    //    Error.WriteLog_Conditional("GraphClientException - " + ex.Message);
            //    //}

            //    throw ex;
            //}
            //catch (Exception ex)
            //{
            //    //if (Convert.ToBoolean(WriteLog))
            //    //{
            //    //    //LogService("Sending Email");
            //    //    Error.WriteLog_Conditional("GraphClientException - " + ex.Message);
            //    //}

            //    throw ex;
            //}
        }
    }
}
