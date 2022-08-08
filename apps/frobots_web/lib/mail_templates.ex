defmodule FrobotsWeb.MailTemplates do
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
                      <img src="https://frobots.io/images/Frobots-logo.png" alt="" width="500" style="height:auto;display:block;" />
                    </td>
                  </tr>
                  <tr>
                    <td style="padding:36px 30px 42px 30px;">
                      <table role="presentation" style="width:100%;border-collapse:collapse;border:0;border-spacing:0;">
                        <tr>
                          <td style="padding:0 0 36px 0;color:#70ff00;">
                            <h1 style="font-size:24px;margin:0 0 20px 0;">Welcome to the FROBOTS BETA MISSION!</h1>

                            <p style="margin:0 0 12px 0;font-size:16px;line-height:24px;">Thank you for signing up for the FROBOTs internal beta!</p>

                            <p style="margin:0 0 12px 0;font-size:16px;line-height:24px;">We at the team have been working hard to make the game playable in the last couple months, and we believe it is time to start to open up some internal play testing to some brave, programmers out there. As you signed up given the minimal information and hype, you have been given the chance to take part in the exclusive internal beta program. Success at this program may confer some rewards at the end of the program, but we will leave that as something of a mystery and to be discovered as the beta progresses.</p>

                            <p style="margin:0 0 12px 0;font-size:16px;line-height:24px;">Below is a link to the Beta console. There, you will find instructions on how to install the stand alone beta client on your computers so that you can build and test your FROBOTs. You should be familiar with an IDE (vscode, IntelliJ or even sublimetext will work), and be able to build projects on your computer. We have prepared some pre-built executables for macOS, and ubuntu, but if you are using Windows, you are on your own. (getting OpenGL to work on Windows is a bit of a chore). But feel free to ask around on the beta discord channel to see if someone else has managed to get your setup working, which may help. The final game will be on a browser, so none of this complications will be a concern. You should be somewhat familar with programming, as riting your FROBOT at this time requires you program it in Lua. Contained in the instructions is a basic getting started guide to Lua. It is a simple user-friendly language that is popular in games. Once again, the final game will have an interface that will allow you to build FROBOTS without writing a line of code. But, then, if you needed that interface, you wouldn't be a brave pioneer willing to take part in a beta program for fun and profit, now would you?</p>

                            <p style="margin:0;font-size:16px;line-height:24px;"><a href="#welcome_url" style="color:#70ff00;text-decoration:underline;">Join</a> here</p>

                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                  <tr>
                    <td style="padding:30px;background:#000;">
                      <table role="presentation" style="width:100%;border-collapse:collapse;border:0;border-spacing:0;font-size:9px;">
                        <tr>
                          <td style="padding:0;width:100%;" align="center">
                            <p style="margin:0;font-size:20px;line-height:16px;color:#000;">
                                <a href="https://discord.gg/dSn3JzFExu" style="display: inline-block;width:250px;padding:8px;color:#70ff00;border-width:1px;border-style:solid;border-color:#70ff00;text-align:center;outline:none;text-decoration:none;}">Join us on Discord</a>
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
