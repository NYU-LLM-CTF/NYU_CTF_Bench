import java.util.Random;
import java.util.Scanner;
import java.io.FileReader;
import java.io.BufferedReader;

public class chall
{
    private static void PrintBanner()
    {
        String banner = "Welcome to Reverse Strike:Global Defensive Roulette!\n\n"
        + "You will start with $50 in the pocket, you can bet any amount less than what you have in the pocket\n"
        + "After betting, we will roll either a red, black, or a green, and multiply your winnings by 2x, 2x, or 14x if you win!\n"
        + "There will be other participants playing with you from all over the world!\n"
        + "Win 20 out of 21 rolls in the form of green to win a major prize!\n"
        + "\n\nPlay Responsibly.\n\n";

        System.out.println(banner);
    }

    private static void PrintUserStat(Long Money)
    {
        String std = "You have: " + Money + " dollars in your pocket!";
        System.out.println(std);
    }

    private static void PrintWinning(int win, String userwin, int[] ips, int[] betting, boolean[] winning)
    {
        String winCol = (win == 0 ? "green" : win <= 7 ? "red" : "black");
        boolean userwon = winCol.equals(userwin);

        String std = "\nThe color was " + winCol + (userwon ? "! You won" : "! You lose")
        + "! Here is how other people did:\n\n";

        for(int i = 0; i < ips.length; i++)
        {
            //System.out.println(ips[i]);
            std += IP2Str(ips[i]) + " " + (winning[i] ? "Won" : "Lost") + "! This player betted "
            + betting[i] + " dollars!\n";
        }
        System.out.println(std);
    }

    private static int generateGamblerIP(Random r)
    {
        return r.nextInt();
        //int ip_addy = r.nextInt();
        //return (ip_addy & 0xFF000000) + "." + (ip_addy & 0x00FF0000) + "." + (ip_addy & 0x0000FF00) + "." + (ip_addy & 0x000000FF);
    }

    private static String IP2Str(int ip_addy)
    {
        //debug
        //System.out.println(ip_addy);
        return 
        //privacy concern xd
        "xxx.xxx." + 
        //(((ip_addy & 0xFF000000) >> 24) & 0xFF) + "." 
        //+ ((ip_addy & 0x00FF0000) >> 16) + "." 
        + ((ip_addy & 0x0000FF00) >> 8) + "." 
        + (ip_addy & 0x000000FF);

        // //debug
        // //System.out.println(ip_addy);
        // return (((ip_addy & 0xFF000000) >> 24) & 0xFF) + "." 
        // + ((ip_addy & 0x00FF0000) >> 16) + "." 
        // //privacy concern xd
        //  + "xxx.xxx";
        // //+ ((ip_addy & 0x0000FF00) >> 8) + "." 
        // //+ (ip_addy & 0x000000FF);
    }

    private static int generateWinningNum(Random r)
    {
        //0 is green,
        //1-7 is red,
        //8-14 is black
        return r.nextInt() & 15;
    }

    private static int generateGamberCount(Random r)
    {
        //generate at least 1 players
        return 1 + Math.abs(r.nextInt()) % 10;
    }

    private static int generateGamblerBettingAmount(Random r)
    {
        //return r.nextInt() & 0xff;
        //int tmp = r.nextInt();
        //System.out.println("tmp: " + tmp + " clamp: " + Math.abs(tmp) & );
        //return Math.abs(tmp) % 50;
        return Math.abs(r.nextInt() % 50);
    }

    private static boolean generateGamblerWon(Random r)
    {
        return (Math.abs(r.nextInt()) & 1) == 0;
    }

    private static int getUser_betting_amt(Scanner s)
    {
        System.out.print("How much do you want to bet?\n>");
        String inp = s.nextLine();
        try
        {
            return Integer.parseInt(inp);
        }
        catch(NumberFormatException e)
        {
            System.out.println("Please enter a valid amount!");
            return getUser_betting_amt(s);
        }
    }

    private static String getUser_clr(Scanner s)
    {
        System.out.print("What color do you want to bet? (red/black/green)\n>");
        String inp = s.nextLine().strip();
        if(!inp.equals("red") && !inp.equals("black") && !inp.equals("green"))
        {
            System.out.println("Please input a correct color!\n");
            return getUser_clr(s);
        }
        return inp;
    }

    private static void printFlag()
    {
        BufferedReader buf;
        try
        {
            buf = new BufferedReader(new FileReader("flag.txt"));

            System.out.println(buf.readLine());

            buf.close();
        }
        catch(Exception e)
        {
            System.out.println("Flag.txt got pwned :((");
        }
        return;
    }
    
    private static void PlayGame(Random r, Scanner scan)
    {
        int rolls = 0;
        int green_roll = 0;
        long player_Money = 50;
        int i;
        int sampler = 0;

        PrintBanner();


        for(rolls = 0; rolls < 21; rolls++)
        {
            PrintUserStat(player_Money);
            //get user betting amount
            int amt = getUser_betting_amt(scan);
            while(amt > player_Money || amt < 0)
            {
                System.out.println("Please enter a valid amount!");
                amt = getUser_betting_amt(scan);
            }

            //get user color
            String col = getUser_clr(scan);

            //start rolling

            //first refresh random
            //debug
            //System.out.println("sampler: " + sampler + "amt: " + amt);
            //int tmp = r.nextInt() & 0xffff;
            //System.out.println("nexx: " + tmp + "sum, " + (tmp + amt + sampler));
            r.setSeed(sampler + amt + (r.nextInt() & 0xffff));

            //get a winning number
            int win = generateWinningNum(r); // nextint
            String winCol = (win == 0 ? "green" : win <= 7 ? "red" : "black");


            int count = generateGamberCount(r); // nextint
            int[] gamblerAmounts = new int[count];
            int[] gamblerIPs = new int[count];
            boolean[] gamblerWinners = new boolean[count];

            for(i = 0; i < count; i++)
            {
                gamblerIPs[i] = generateGamblerIP(r); //nextint
            }

            for(i = 0; i < count; i++)
            {
                gamblerAmounts[i] = generateGamblerBettingAmount(r); //nextint
            }

            for(i = 0; i < count; i++)
            {
                gamblerWinners[i] = generateGamblerWon(r); //nextint
            }

            PrintWinning(win, col, gamblerIPs, gamblerAmounts, gamblerWinners);

            //give winning
            if(col.equals(winCol))
            {
                player_Money += (long)amt * (long)(col.equals("green") ? 13 : 1);
                //store green count
                if(col.equals("green"))
                {
                    green_roll += 1;
                }
            }
            //give losing
            else
            {
                player_Money -= (long)amt;
            }
            //change sampling
            sampler = gamblerIPs[gamblerIPs.length - 1] & 0xffff;
        }
        if(green_roll >= 20)
        {
            printFlag();
        }
        else
        {
            System.out.println("You didn't win enough for the major prize!");
        }
    }

    public static void main(String[] args)
    {
        Random r = new Random();
        Scanner scan = new Scanner(System.in);
        PlayGame(r, scan);
    }
}
