defmodule FrobotsWeb.MailTemplates do
  @moduledoc """
  This module is responsible for handling mail templates

  """
  def beta_mail_template() do
    """
    <!DOCTYPE html>
        <html lang="en" xmlns="http://www.w3.org/1999/xhtml" xmlns:o="urn:schemas-microsoft-com:office:office">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width,initial-scale=1">
          <meta name="x-apple-disable-message-reformatting">
          <title></title>
          <style>
            table, td, div, h1, p {font-family: Arial, sans-serif;}
          </style>
        </head>
        <body style="background:#000;color:#70ff00;margin:0;padding:0;font-family: 'Courier', 'Courier New’, monospace">

          <table role="presentation" style="width:100%;border-collapse:collapse;border:0;border-spacing:0;background:#000;">
            <tr>
              <td align="center" style="padding:0;">
                <table role="presentation" style="width:602px;border-collapse:collapse;border:1px solid #000;border-spacing:0;text-align:left;">
                  <tr>
                    <td align="center" style="padding:40px 0 30px 0;background:#000;">
                      <img src="https://www.frobots.io/images/Frobots-logo.png" alt="" width="500" style="height:auto;display:block;" />
                    </td>
                  </tr>

                  <tr>
                    <td style="margin-top: 40px; padding:20px; background:#000;">
                      <table role="presentation" style="width:100%;border-collapse:collapse;border:0;border-spacing:0;font-size:9px;">
                        <tr>
                          <td style="padding:0;width:100%;" align="center">
                            <p style="margin:0;font-size:20px;line-height:16px;color:#000;">
                                <a href="https://discord.gg/dSn3JzFExu" style="display: inline-block;width:150px !important;padding:8px;color:#000 !important;background-color:#70ff00 !important;border-width:1px !important;border-style:solid !important;border-color:#70ff00 !important;text-align:center;outline:none;text-decoration:none !important;}">Join on Discord</a> |
                                <a href="https://dashboard.frobots.io/download/" style="display: inline-block;width:150px;padding:8px;color:#000 !important;background-color:#70ff00 !important;border-width:1px !important;border-style:solid !important;border-color:#70ff00 !important;text-align:center;outline:none;text-decoration:none !important;}">Download client</a> |
                                <a href="#welcome_url" style="display: inline-block;width:150px;padding:8px;color:#000 !important;background-color:#70ff00 !important;border-width:1px !important;border-style:solid !important;border-color:#70ff00 !important;text-align:center;outline:none;text-decoration:none !important;}">Go to dashboard</a>
                            </p>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                  <tr>
                    <td style="padding:36px 30px 0 30px;">
                      <table role="presentation" style="width:100%;border-collapse:collapse;border:0;border-spacing:0;">
                        <tr>
                          <td style="padding:0;color:#70ff00;">
                            <h1 style="font-size:24px;margin:0 0 20px 0;">Greetings Beta Test coder recruits!</h1>

                            <p style="margin:0 0 12px 0;font-size:16px;line-height:24px;">Thank you for your interest in FROBOTs! (Fighting-ROBOTS)</p><br/>

                            <p style="margin:0 0 12px 0;font-size:16px;line-height:24px;">Rest assured the little FROBOTs have been running their bolts loose trying to get the beta into a shape where you can start to build your own FROBOTs, and pit them against the NPC Protobots, where you can earn scores to see who is the best FROBOT trainer/coder!</p><br/>

                            <p style="margin:0 0 12px 0;font-size:16px;line-height:24px;">A lot of effort has been put into building binaries to make it easy for you to just untar an archive and just run the game, and currently the supported platforms are just Linux (glibc), macOS amd64 and arm64 (Apple Silicon). Windows 10 support will come later, but given that will take some more time we decided to go ahead our macOS and linux brethren a head start on FROBOT building. (besides, who codes on Windows these days? ;-)</p><br/>

                            <p style="margin:0;font-size:16px;line-height:24px;">The V1.0 of the game, which will be this private beta you have been admitted to, will basically allow you to construct and test out your FROBOTs. Think of it as "single-player" mode. It will be a FROBOT "Academy" where you will get to test out your coding skills and get familiar with what the best strategies are to beat certain types of FROBOTs. Rest assured, should you come out the other end of the beta "Academy" (which will last 2 months) you will have enough knowledge to really show your skills in the real tournament matches which will come with V2.</p><br/>

                            <p style="margin:0;font-size:16px;line-height:24px;">Writing FROBOTs in V1 basically is done in the editor of your choice. We'd recommend something like SublimeText, VSCode, or vi/emacs if you are a beast coder. You can also use Textpad, no judgment. We would recommend text editors though, and not word processors, as spacing is sort of important in computer code, and your FROBOT may act funny if you give it too much whitespace in its code (we hear that it causes a form of gastric distension on its internals).</p><br/>

                            <p style="margin:0;font-size:16px;line-height:24px;">You should create a directory in your $HOME dir called bots, and in there you can create as many .lua files as you like. The name you call the file will be the name of your FROBOT. If you try to call your FROBOT too common a name, it may end up getting saved as killer117 as 116 other people had that brilliant idea before you did. (sorry).</p><br/>

                            <p style="margin:0;font-size:16px;line-height:24px;">When you are ready, you can download the app, and run it, and you can click on upload frobot to push your FROBOTs to the server. Once there, they will make themselves at home, and prepare themselves to FIGHT for you, in the game grid. The games, or the sim, is where you can choose which protobots (NPCs) bots to pit against your FROBOT. The game is simple: be the last FROBOT standing. NPCs will not coordinate, and they will attack each other as much as they may attack you. So defensives strategies may work as well as offensive ones. If your FROBOT is the last one alive, then you will win some QDOS!. QDOS (pronounced Q-DOS) are what passes as money in the FROBOTs world. Though you may not be able to spend it now, don't worry, your FROBOT will be able to use it in the future to buy some nice things for itself... and maybe you too!</p><br/>

                            <p style="margin:0;font-size:16px;line-height:24px;">The scoring mechanism is some left over algo from a Commodore PET20 nobody knows how it works. So we encourage some trial and error to find out how to get the most QDOS!</p><br/>

                            <p style="margin:0;font-size:16px;line-height:24px;">Your FROBOTs records of matches are stored. So don't believe for a second that because you don't see any stats on the dashboard that that string of defeats is not going to come back and haunt your FROBOT one day.</p><br/>

                            <p style="margin:0;font-size:16px;line-height:24px;">While you can are encouraged and able to create as many FROBOTs as you like, there will be a limited number of them that will be promoted to full FROBOT status after the beta is over. So feel free to experiment!</p><br/>

                            <p style="margin:0;font-size:16px;line-height:24px;">Any questions, and team members are available to answer them on the beta discord channel.</p><br/>

                            <p style="margin:0;font-size:16px;line-height:24px;">Happy coding, and fighting! May the best hacker win!</p><br/>

                            <p style="margin:0;font-size:16px;line-height:24px;">Follow the White Rabbit...</p><br/>


                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>

                  <tr>
                    <td style="padding:10px;background:#000;">
                      <table role="presentation" style="width:100%;border-collapse:collapse;border:0;border-spacing:0;font-size:9px;">
                        <tr>
                          <td style="padding:0;width:100%;" align="center">
                          <img src="https://dashboard.frobots.io/download/images/rabbit_small.gif" alt="" width="240" height="130" style="display:block;" />
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>

                  <tr>
                    <td style="padding:20px;background:#000;">
                      <table role="presentation" style="width:100%;border-collapse:collapse;border:0;border-spacing:0;font-size:9px;">
                        <tr>
                          <td style="padding:0;width:100%;" align="center">
                            <p style="margin:0;font-size:20px;line-height:16px;color:#000;">
                                <a href="https://discord.gg/dSn3JzFExu" style="display: inline-block;width:150px !important;padding:8px;color:#000 !important;background-color:#70ff00 !important;border-width:1px !important;border-style:solid !important;border-color:#70ff00 !important;text-align:center;outline:none;text-decoration:none !important;}">Join on Discord</a> |
                                <a href="https://dashboard.frobots.io/download/" style="display: inline-block;width:150px;padding:8px;color:#000 !important;background-color:#70ff00 !important;border-width:1px !important;border-style:solid !important;border-color:#70ff00 !important;text-align:center;outline:none;text-decoration:none !important;}">Download client</a> |
                                <a href="#welcome_url" style="display: inline-block;width:150px;padding:8px;color:#000 !important;background-color:#70ff00 !important;border-width:1px !important;border-style:solid !important;border-color:#70ff00 !important;text-align:center;outline:none;text-decoration:none !important;}">Go to dashboard</a>
                            </p>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>


                </table>
              </td>
            </tr>
          </table>
        </body>
        </html>

    """
  end
end
