using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Net.Http;
using System.Threading.Tasks;

namespace MIFunction
{
    public static class Function1
    {
        [FunctionName("ManagedIdentityTest")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            //string AuthorityFormat = "https://login.microsoftonline.com/{0}/v2.0";
            var clienID = "c7aaf45f-68cd-4b2c-9ae1-3645762a2a79";
            // var clienID = "d761da1c-073d-4429-bce9-a0ee44802ebb";



            //var clientSecret = "r.A6QCNqiprlobfh~S89B4eD0DB_O.Mxn5";
            //var tenantId = "e4022446-350c-4e31-8a9e-c0e887dbe6f8";
            //string Scope = "api://d761da1c-073d-4429-bce9-a0ee44802ebb/.default";

            //IConfidentialClientApplication daemonClient;
            //daemonClient = ConfidentialClientApplicationBuilder.Create(clienID)
            //    .WithAuthority(string.Format(AuthorityFormat, tenantId))
            //    .WithClientSecret(clientSecret)
            //    .Build();

            log.LogInformation("C# HTTP trigger function processed a request.");
            log.LogInformation("IDENTITY_ENDPOINT: " + Environment.GetEnvironmentVariable("IDENTITY_ENDPOINT"));
            log.LogInformation("IDENTITY_HEADER: " + Environment.GetEnvironmentVariable("IDENTITY_HEADER"));

            // AuthenticationResult authResult = await daemonClient.AcquireTokenForClient(new[] { Scope }).ExecuteAsync();


            //var adCredential = new ClientCredential(clienID, clientSecret );
            //var authenticationContext = new AuthenticationContext("https://login.microsoftonline.com/e4022446-350c-4e31-8a9e-c0e887dbe6f8");
            //var token = await authenticationContext.AcquireTokenAsync(clienID, adCredential);
            //var accessToken = token.AccessToken;
            string accessToken = null;
            /***/
            try
            {
                var azServiceTokenProvider = new AzureServiceTokenProvider();
                accessToken = await azServiceTokenProvider.GetAccessTokenAsync(clienID);
                log.LogInformation("bearer: " + accessToken);
            }
            catch(Exception ex)
            {
                log.LogError(ex, "ERROR 1: " + ex.Message );
            }
            /**/

            log.LogInformation("SECOND OPTION HTTP CALL.");
            HttpClient _client = new HttpClient();

            var request = new HttpRequestMessage(HttpMethod.Get,
            String.Format("{0}/?resource={1}&api-version=2019-08-01", Environment.GetEnvironmentVariable("IDENTITY_ENDPOINT"), clienID));
            request.Headers.Add("X-IDENTITY-HEADER", Environment.GetEnvironmentVariable("IDENTITY_HEADER"));
            var response = await _client.SendAsync(request);


            log.LogInformation("http status code: " + response.StatusCode.ToString());
            log.LogInformation("bearer 2: " + response.Content.ReadAsStringAsync().Result);


            /**/

            var wc = new HttpClient();

            wc.DefaultRequestHeaders.TryAddWithoutValidation("Authorization", "Bearer " + response);
            var stringContent = new StringContent("This is a test");
            //var result = await wc.GetAsync("https://nicojkwebapi2.azurewebsites.net/weatherforecast");
            var result = await wc.PostAsync("https://api.victor-nonprod.fedex.io/sim/v1/transportation/selectionservice/scores", stringContent);

            if (result.StatusCode != System.Net.HttpStatusCode.OK)
            {
                throw new Exception("ERROR: " + result.StatusCode.ToString());
            }

            var content = await result.Content.ReadAsStringAsync();

            string responseMessage = content;

            return new OkObjectResult(responseMessage);
        }
    }
}
