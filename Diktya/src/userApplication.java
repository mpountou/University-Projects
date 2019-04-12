import java.util.Scanner;

import java.net.*;
import java.io.*;
import java.util.ArrayList;


public class userApplication {
    public static void main(String[] param) {
        // session id
        int serverPort= 38021; // MUST BE FILLED
        int clientPort= 48021; // MUST BE FILLED
        int echo_code_delay = 5489; // MUST BE FILLED
        // initialize scanner
        Scanner scanner = new Scanner(System.in);
        //time to choose
        int userChoice = 0;
        // printing choices
        System.out.print("\n1. Create Datagrams G1,G2");
        System.out.print("\n2. Create Datagrams G3,G4\n");
        // get user choice
        userChoice = Integer.parseInt(scanner.nextLine());
        // apply
        if(userChoice == 1 || userChoice == 2) {
            try {
                echo(echo_code_delay, userChoice, serverPort, clientPort);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }


    }

    public static void echo(int echo_code,int echo_case,int serverPort,int clientPort) throws SocketException,IOException,UnknownHostException{
        // used to print echo packet messages
        String echo_message="";
        // gives the correct name to output files for both cases
        String chosen_mode="";
        // echo packet code from the session
        String code ="";
        if(echo_case==1){
            chosen_mode="case_delay";
            code="E" + Integer.toString(echo_code) +"\r";
        }else if (echo_case == 2){
            chosen_mode="case_without_delay";
            code="E0000\r";
        }
        //init InetAddress
        byte[] hostIP = { (byte)155,(byte)207,18,(byte)208 };
        InetAddress hostAddress = InetAddress.getByAddress(hostIP);
        // getArray of bytes
        byte[] code_byte = code.getBytes();
        // init DatagramSocket
        DatagramSocket sendSocket = new DatagramSocket();
        DatagramPacket sendPacket = new DatagramPacket(code_byte,code_byte.length, hostAddress,serverPort);
        DatagramSocket recieveSocket = new DatagramSocket(clientPort);
        recieveSocket.setSoTimeout(3600);
        // init arrayOf bytes
        byte[] recieve_byte = new byte[2048];
        DatagramPacket recievePacket = new DatagramPacket(recieve_byte,recieve_byte.length);
        // time of packets will be saved here
        ArrayList<Double> arrayList_timePacket = new ArrayList<Double>();
        // we will count all packets recieved
        int packet_counter=0;
        // time variables
        double timeElapsed=0;
        double averageTime=0;
        double beginSession=0;
        double endSession=0;
        double beginTime=0;
        double endTime=0;
        // get current time
        beginSession = System.nanoTime();
        // set time for recieving packets
        int five_minutes_session = 5*60*1000;
        // results of session will be saved here
        ArrayList<String> arrayList_output = new ArrayList<String>();
        // begin loop
        while(endSession<five_minutes_session){
            //sending one packet
            sendSocket.send(sendPacket);
            // update time
            beginTime = System.nanoTime();
            // increase counter
            packet_counter++;
            for (;;) {
                try {
                    // recieve packet
                    recieveSocket.receive(recievePacket);
                    // update end time
                    endTime=(System.nanoTime()- beginTime)/1000000;
                    // print message
                    echo_message = new String(recieve_byte,0,recievePacket.getLength());
                    System.out.println(echo_message);
                    // print time response
                    System.out.print(""+endTime+"\n");
                    break;
                } catch (Exception x) {
                    System.out.println(x);
                    break;
                }
            }
            // update time elapsed
            timeElapsed+=endTime;
            // add endTime
            arrayList_timePacket.add(endTime);
            // update ArrayList for output file
            arrayList_output.add(""+endTime);
            // update endSession
            endSession=(System.nanoTime()-beginSession)/1000000;
        }
        // some handy statistics for our report
        ArrayList<String> arrayList_stats = new ArrayList<String>();
        // average time
        averageTime=timeElapsed/packet_counter;
        arrayList_stats.add("Session time :"+(timeElapsed/60)/1000+" minutes\n");
        arrayList_stats.add("Total time : "+(endSession/60)/1000+" minutes\n");
        arrayList_stats.add("Total number of packets : "+String.valueOf((double)packet_counter));
        arrayList_stats.add("Total average time : "+String.valueOf(averageTime));
        double sum=0;
        float counter=0;
        ArrayList<Float> counters = new ArrayList<Float>();
        for(int i = 0; i < arrayList_timePacket.size();i++){
            int j = i;
            while((sum < 8*1000)&&(j < arrayList_timePacket.size())){
                sum += arrayList_timePacket.get(j);
                counter++;
                j++;
            }
            counter = counter/8;
            counters.add(counter);
            counter = 0;
            sum = 0;
        }
        // create output file
        BufferedWriter bufferedWriter = null;
        try{
            String fileDestination = "Echo_"+echo_code+"_"+chosen_mode+".txt";
            File file =new File(fileDestination);
            bufferedWriter = new BufferedWriter(new FileWriter(fileDestination, false));
            if(!file.exists()){
                file.createNewFile();
            }
            for (int i=0; i <arrayList_output.size(); i++){

                bufferedWriter.write(String.valueOf(arrayList_output.get(i)));
                bufferedWriter.newLine();
            }
            bufferedWriter.newLine();
        }catch(IOException ioe){
            ioe.printStackTrace();
        }
        finally{
            try{
                if(bufferedWriter != null) bufferedWriter.close();
            }catch(Exception ex){
                System.out.println("Error in closing the BufferedWriter" + ex);
            }
        }

        bufferedWriter = null;

        try{
            String fileDestination = "Echo_Statistics_"+echo_code+"_"+chosen_mode+".txt";
            File file =new File(fileDestination);
            bufferedWriter = new BufferedWriter(new FileWriter(fileDestination, false));
            if(!file.exists()){
                file.createNewFile();
            }
            for (int i=0; i <arrayList_stats.size(); i++){

                bufferedWriter.write(String.valueOf(arrayList_stats.get(i)));
                bufferedWriter.newLine();
            }
            bufferedWriter.newLine();
        }catch(IOException ioe){
            ioe.printStackTrace();
        }
        finally{
            try{
                if(bufferedWriter != null) bufferedWriter.close();
            }catch(Exception ex){
                System.out.println("Error in closing the BufferedWriter" + ex);
            }
        }

        bufferedWriter = null;

        try{
            String finalDestination = "Echo_R_"+echo_code+"_"+chosen_mode+".txt";
            File file =new File(finalDestination);
            bufferedWriter = new BufferedWriter(new FileWriter(finalDestination, false));
            if(!file.exists()){
                file.createNewFile();
            }
            for (int i=0; i <counters.size(); i++){

                bufferedWriter.write(String.valueOf(counters.get(i)));
                bufferedWriter.newLine();
            }
            bufferedWriter.newLine();
        }catch(IOException ioe){
            ioe.printStackTrace();
        }
        finally{
            try{
                if(bufferedWriter != null) bufferedWriter.close();
            }catch(Exception ex){
                System.out.println("Error in closing the BufferedWriter" + ex);
            }
        }
        recieveSocket.close();
        sendSocket.close();

    }
}