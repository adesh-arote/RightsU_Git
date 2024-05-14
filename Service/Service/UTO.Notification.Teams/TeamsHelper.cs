using Azure.Identity;
using Microsoft.Graph;
using Microsoft.Graph.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UTO.Notification.Teams
{
    public class TeamsHelper
    {
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

        public static Chat GetChatPayload(string FromAddress, List<string> ToAddress, ChatType chatType)
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
                                        "user@odata.bind" , "https://graph.microsoft.com/v1.0/users('"+ToAddress.FirstOrDefault()+"')"
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

        public static async Task<ChatMessage> SendTeamNotification(List<string> ToAddress, ChatType chatType, string MsgBody, USPGetConfig objConfig)
        {
            try
            {
                var graphClient = GetGraphServiceClient(objConfig);

                var chatPayload = GetChatPayload(objConfig.UserName, ToAddress, chatType);

                var objChat = await graphClient.Chats.PostAsync(chatPayload);

                var requestBodyMessage = new ChatMessage
                {
                    Body = new ItemBody
                    {
                        ContentType = BodyType.Html,
                        Content = MsgBody,
                    },
                };

                var chatMessage = await graphClient.Chats[objChat.Id].Messages.PostAsync(requestBodyMessage);

                return chatMessage;
            }
            catch (ServiceException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
