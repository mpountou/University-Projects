package com.diktia;

import ithakimodem.Modem;

import java.io.*;
import java.util.ArrayList;

public class userApplication {

    public static int k; //global variable to read modem
    public static void main(String[] param) throws IOException {

        ArrayList<Long> response_time = new ArrayList<Long>();

        Modem echo_modem; //creates variable echo modem

        echo_modem = new Modem(8000); //initialize..

        echo_modem.setSpeed(8000); //set speed

        echo_modem.setTimeout(2000); //set timeout

        String dial = "ATD2310ITHAKI\r";

        echo_modem.write(dial.getBytes());

        for (;;) {//reading welcome notes

            try {

                k = echo_modem.read(); //get results from server

                if (k == -1) break; //connection timed out

                System.out.print((char) k);
            }
            catch (Exception x) {

                break;
            }
        }//end of welcome notes

        //
        System.out.println("HI");
        long timeStarted = System.currentTimeMillis(); //get time of starting sending echo_packets

        long timePassed; //variable usefull to see how much time passed

        String code_echo = ""; //echo_package code

        do {

            System.out.println("SENDING PASSOWRD");

            code_echo = "E6998\r"; //set code

            long time_of_sending_started = System.currentTimeMillis(); //get initiate time

            echo_modem.write(code_echo.getBytes()); //send request

            for (int i = 0; i < 35; i++) {

                try {

                    k = echo_modem.read(); // reanding package from server

                    if (k == -1) break;

                    System.out.print((char) k); // print message
                }
                catch (Exception x) {

                    break;
                }
            }
            long time_of_recieving_ended = System.currentTimeMillis(); //get time after recieving echo_packet

            long temp_response = time_of_recieving_ended - time_of_sending_started; //calc response time

            response_time.add(temp_response); //add time to arraylist

            timePassed = System.currentTimeMillis() - timeStarted; // update time passed



        }
        while (timePassed < 250000); // do this for 250 seconds

        PrintWriter writer = new PrintWriter("echo_session1.txt", "UTF-8"); //initiate printwriter

        for (long l : response_time) {

            String temp = String.valueOf(l); //get item

            writer.println(temp); //write it to echo_response.txt

        }
        writer.close(); //save file

        echo_modem.close();

        ArrayList<Integer> arrayList_image_noerror = new ArrayList<Integer>(); //ArrayList for saving image to bytes

        //IMAGE WITHOUT ERROR

        Modem modem_image = new Modem(); //init modem

        modem_image.setSpeed(80000); //set speed

        modem_image.open("ithaki"); //set destination

        String image_code = "M8595\r"; //set code

        char[] arrayChar = image_code.toCharArray(); //transforms code to array of char

        int length = arrayChar.length; //get length

        //send request
         modem_image.write(image_code.getBytes());

        int count=0;//init counter

        for (;;) {

            try {

                k = modem_image.read(); //read from server

                if(count<208) {

                    ++count; // this counter is for skiping welcome notes

                }
                if(count>205){

                    arrayList_image_noerror.add(k); //after welcome notes ... we save image in arraylist

                    System.out.print((char) k);
                }
                if (k == -1) {

                    break;
                }

            }
            catch (Exception x) {
                break;
            }

        }//end of reading image


        int size = arrayList_image_noerror.size(); //get size of arraylist

        byte[] array = new byte[size]; //create byte array with the same size as the arraylist

        for (int a = 0; a < size; a++) {

            array[a] = arrayList_image_noerror.get(a).byteValue(); //get byte values

        }
        //time to save image
        OutputStream out = null;

        try {
            try {
                out = new BufferedOutputStream(new FileOutputStream("image_noerror.jpg"));
                out.write(array);
            } catch (IOException e) {

            }
        } finally {
            if (out != null) {
                try {

                    out.close();
                } catch (IOException ex) {

                }
            }
        }

        //end of saving image_noerror.jpg

        modem_image.close();

        //image with error

        ArrayList<Integer> arrayList_image_error = new ArrayList<Integer>(); //ArrayList for saving image to bytes

        Modem modem_image_error = new Modem(); //init modem

        modem_image_error.setSpeed(80000); //set speed

        modem_image_error.open("ithaki"); //set destination

        String error_code = "G1260\r";//ERROR CODE initiated here

        //send request
        modem_image_error.write(error_code.getBytes());

        int count_error=0;// counter for skiping welcome notes

        for (;;) {

            try {

                k = modem_image_error.read(); //read from server

                if(count_error<208) {

                    ++count_error;

                }
                if(count_error>205){

                    arrayList_image_error.add(k); //start saving error image

                    System.out.print((char) k);

                }
                if (k == -1) {

                    break;
                }

            }
            catch (Exception x) {
                break;
            }

        }

        int size_error = arrayList_image_error.size(); //get size of arraylist

        byte[] array_error = new byte[size_error]; //create byte array for saving error image

        for (int a = 0; a < size_error; a++) {

            array_error[a] = arrayList_image_error.get(a).byteValue(); //get byte values

        }

        //time to save error image

        OutputStream out_error = null;

        try {
            try {
                out_error = new BufferedOutputStream(new FileOutputStream("image_error.jpg"));
                out_error.write(array_error);
            } catch (IOException e) {

            }
        } finally {
            if (out_error != null) {
                try {

                    out_error.close();
                } catch (IOException ex) {

                }
            }
        }

        modem_image_error.close(); // closing error modem

        Modem gps_modem = new Modem(); //init gps modem

        gps_modem.setSpeed(80000); //set speed

        gps_modem.open("ithaki"); //set destination

        String code = "P5537"; // gps_code

        String gpsInput = code + "R=1000020\r"; //request

        String gpsData = "";

        gps_modem.write(gpsInput.getBytes());

        int count_gps=0;

        String gps_ = "";
        for (;;) {
            try {
                k = gps_modem.read();

                if(count_gps<240) {
                    ++count_gps;
                }
                if(count_gps>230){
                    char c = (char) k ;
                    gps_ = gps_+c;
                    System.out.print((char) k);
                }
                if (k == -1) {

                    break;
                }

            } catch (Exception x) {
                break;
            }

        }


        String[] gps_array = gpsArrayGenerator(gps_);

        String[] parts_ofline1 = gps_array[1].split(",");

        String width_ofline1 = parts_ofline1[2]; //get width line 1

        String[] parts_ofline6 = gps_array[6].split(",");

        String width_ofline6 = parts_ofline6[2]; //get width line 6

        String[] parts_ofline11 = gps_array[11].split(",");

        String width_ofline11 = parts_ofline11[2]; //get width line 11

        String[] parts_ofline16 = gps_array[16].split(",");

        String width_ofline16 = parts_ofline16[2]; //get width line 16

        //string spliting

        String gps_width1 = width_ofline1; //width1 set

        String gps_width2 = width_ofline6; //width2 set

        String gps_width3 = width_ofline11;//width3 set

        String gps_width4 = width_ofline16;//width4 set

        String length_ofline1 = parts_ofline1[4];

        String length_ofline6 = parts_ofline6[4];

        String length_ofline11 = parts_ofline11[4];

        String length_ofline16 = parts_ofline16[2];

        String gps_length1 = length_ofline1;//length1 set

        String gps_length2 = length_ofline6;//length2 set

        String gps_length3 = length_ofline11;//length3 set

        String gps_length4 = length_ofline16;//length4 set

        //time to split width

        String[] splitWidth1 = gps_width1.split("\\.");

        String[] splitWidth2 = gps_width2.split("\\.");

        String[] splitWidth3 = gps_width3.split("\\.");

        String[] splitWidth4 = gps_width4.split("\\.");

        String part1_ofwidth1 = splitWidth1[1];

        String part1_ofwidth2 = splitWidth2[1];

        String part1_ofwidth3 = splitWidth3[1];

        String part1_ofwidth4 = splitWidth4[1];

        //time to split length

        String[] splitLength1 = gps_length1.split("\\.");

        String[] splitLength2 = gps_length2.split("\\.");

        String[] splitLength3 = gps_length3.split("\\.");

        String[] splitLength4 = gps_length4.split("\\.");

        String part1_oflength1 = splitLength1[1];//set length1

        String part1_oflength2 = splitLength2[1];//set length2

        String part1_oflength3 = splitLength3[1];//set length3

        String part1_oflength4 = splitLength4[1];//set length4

        //tranformation of decWidths

        int transWidth1 = (int) (Integer.parseInt(part1_ofwidth1)*0.006);

        int transWidth2 = (int) (Integer.parseInt(part1_ofwidth2)*0.006+1);

        int transWidth3 = (int) (Integer.parseInt(part1_ofwidth3)*0.006-1);

        int transWidth4 = (int) (Integer.parseInt(part1_ofwidth4)*0.006);

        //tranformation of decWidths

        int transLength1 = (int) (Integer.parseInt(part1_oflength1)*0.006);

        int transLength2 = (int) (Integer.parseInt(part1_oflength2)*0.006);

        int transLength3 = (int) (Integer.parseInt(part1_oflength3)*0.006);

        int transLength4 = (int) (Integer.parseInt(part1_oflength4)*0.006+1);

        part1_ofwidth1 = transWidth1 +"";

        part1_ofwidth2 = transWidth2 +"";

        part1_ofwidth3 = transWidth3 +"";

        part1_ofwidth4 = transWidth4 +"";

        part1_oflength1 = transLength1 +"";

        part1_oflength2 = transLength2 +"";

        part1_oflength3 = transLength3 +"";

        part1_oflength4 = transLength4 +"";

        ArrayList<Integer> myList = new ArrayList<Integer>();//init myList ArrayList

        String gpsValue = code +"T=2257"+part1_oflength1+"4037"+part1_ofwidth1 +"T=2257"+part1_oflength2+"4037"+part1_ofwidth2+"T=2257"+part1_oflength3+"4037"+part1_ofwidth3+"T=2257"+part1_oflength4+"4037"+part1_ofwidth4+'\r';

        try{

            for(int i=0; i<gpsValue.length();i++)

            {

                gps_modem.write((int)gpsValue.toCharArray()[i]);//sending request points

            }

        }
        catch (Exception e) {

        }
        //reading values
        for (;;) {

            try {

                k = gps_modem.read();//start reading modem again

                if (k==-1) break;

                System.out.print((char)k);

                myList.add(k);//get gps image from server

            }
            catch (Exception x) {
                break;
            }

        }

        byte [] imageMaker = new byte [myList.size()]; //create a byte array

        for (int i = 0; i < imageMaker.length; i++) {

            imageMaker [i] =  myList.get(i).byteValue(); //convert to byte from myList

        }
        //saving image...
        try {

            FileOutputStream fileOutputStream = new FileOutputStream("gps.jpg");

            try {

                fileOutputStream.write(imageMaker);

            }

            finally {

                fileOutputStream.close();

            }

            }
        catch (Exception e) {

            }

        //end of gps

        gps_modem.close();


            //arq part

        String dial_arq_ez;

        int k, F = 0, C = 0, S = 0, n = 1;

            ArrayList<Long> packagetime = new ArrayList<Long>();

            ArrayList<Integer> packagetime_resent = new	ArrayList<Integer>();

            Modem ez_modem;

            ez_modem = new Modem(8000);

            ez_modem.setSpeed(8000);

            ez_modem.setTimeout(2000);

            dial_arq_ez = "ATD2310ITHAKI\r";

            ez_modem.write(dial_arq_ez.getBytes());

             for (;;) {

                try {

                    k = ez_modem.read();

                    if (k == -1) break;

                    System.out.print((char) k);

                }
                catch (Exception x) {

                    break;
                }

            }//reading modem to skip intro message from server

             int xor = 0;

             long timePassed_arq_ez = 0;

             String code_arq_ez;

            code_arq_ez = "Q8475\r";

            ez_modem.write(code_arq_ez.getBytes());

            long getCurrentTIME = System.currentTimeMillis();

            long getCTime = getCurrentTIME;

            do {

                for (int j = 1; j <= 58; j++) {
                    try {

                        k = ez_modem.read();

                        if (k == -1) {

                        System.out.print("Bad");

                        break;

                        }

                         System.out.print((char) k); if (j == 32)

                         xor = k;

                         if (j > 32 && j < 48)

                             xor = k ^ xor;

                         if (j == 50)

                             F = k - 48;

                         if (j == 51)

                             C = k - 48;

                         if (j == 52)

                             S = k - 48;

                    }
                    catch (Exception x) {

                            System.out.print("Exception");

                    break;
                }

                }

                long t2 = System.currentTimeMillis();

                int FCS = F * 100 + C * 10 + S;

                if (xor == FCS) {
                    packagetime.add(t2 - getCTime);
                    packagetime_resent.add(n);
                    n = 1;
                    getCTime = System.currentTimeMillis();
                    code_arq_ez = "Q8475\r"; ez_modem.write(code_arq_ez.getBytes());
                }
                else {
                    n++;
                    code_arq_ez = "R7216\r";
                    ez_modem.write(code_arq_ez.getBytes());
                }

                timePassed_arq_ez = System.currentTimeMillis() - getCurrentTIME;

                System.out.println(" ");
            }
            while (timePassed_arq_ez < 250000); System.out.println(packagetime);

            String listString = "";

            PrintWriter writer_arq = new PrintWriter("arq_response.txt", "UTF-8"); //initiate printwriter

        for (long l : packagetime) {

                listString = String.valueOf(l);

                writer_arq.println(listString);

            }

            writer_arq.close();

        PrintWriter writer_arq_rep = new PrintWriter("arq_rep.txt", "UTF-8"); //initiate printwriter

        String newlistString = "";

        for (long w : packagetime_resent) {

                newlistString = String.valueOf(w);

                writer_arq_rep.println(newlistString

                );
            }

        writer_arq_rep.close();

    }


    public static String[] gpsArrayGenerator(String enteredString){

        String packets[];

        packets = enteredString.split("\\$GPGGA");
        System.out.print(packets.length);
        for(int i=0; i<packets.length;i++){
            if(packets[i].contains("0,0000*")){
                packets[i] = "$GPGGA"+packets[i];
            }
        }
        for(int i=0; i<packets.length;i++){
            System.out.println(packets[i]);
        }
        return packets;
    }


}
