using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNet.Builder;
using Microsoft.AspNet.Hosting;
using Microsoft.AspNet.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.PlatformAbstractions;
using Microsoft.Extensions.Configuration;
using System.Text;

namespace aspcoredemo
{
    public class Startup
    {
        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit http://go.microsoft.com/fwlink/?LinkID=398940
        public void ConfigureServices(IServiceCollection services)
        {
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app)
        {
            var builder = new ConfigurationBuilder();

            builder.AddEnvironmentVariables();
            var config = builder.Build();
            var sb = new StringBuilder();
            sb.AppendLine("SERVICE_NAME: " + config["SERVICE_NAME"]);
            sb.AppendLine("SERVICE_TAGS: " + config["SERVICE_TAGS"]);
            sb.AppendLine("DOCKER_ENV_VAR1: " + config["DOCKER_ENV_VAR1"]);
            app.Run(async (context) =>
            {
            

                await context.Response.WriteAsync("Hello World!\r" + sb.ToString());
            });
            
        }

        // Entry point for the application.
        public static void Main(string[] args)
        {
            WebApplication.Run<Startup>(args);
            IRuntimeEnvironment runtime = PlatformServices.Default.Runtime;
            IApplicationEnvironment env = PlatformServices.Default.Application;
            Console.WriteLine($@"
IApplicationEnvironment:
        Base Path:      {env.ApplicationBasePath}
        App Name:       {env.ApplicationName}
        App Version:    {env.ApplicationVersion}
        Runtime:        {env.RuntimeFramework}
IRuntimeEnvironment:
        OS:             {runtime.OperatingSystem}
        OS Version:     {runtime.OperatingSystemVersion}
        Architecture:   {runtime.RuntimeArchitecture}
        Path:           {runtime.RuntimePath}
        Type:           {runtime.RuntimeType}
        Version:        {runtime.RuntimeVersion}");
        }

    }
}
