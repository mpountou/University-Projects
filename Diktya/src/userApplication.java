import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.SourceDataLine;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Scanner;

import java.net.*;
import java.io.*;
import java.util.ArrayList;


public class userApplication {
    public static void main(String[] param) {
        // session id
        int serverPort =   38006 ; // MUST BE FILLED
        int clientPort =   48006 ; // MUST BE FILLED
        int echo_code_delay =5589 ; // MUST BE FILLED
        int image_code = 6297; // MUST BE FILLED
        int sound_code = 7097; // MUST BE FILLED
        int copter_code = 6001; // MUST BE FILLED
        // initialize scanner
        Scanner scanner = new Scanner(System.in);
        //time to choose
        int userChoice = 0;
        // printing choices
        System.out.print("\n1. Create Datagrams G1,G2");
        System.out.print("\n2. Create Datagrams G3,G4");
        System.out.print("\n3. Create Image E1");
        System.out.print("\n4. Create Image E2");
        System.out.print("\n5. Create Temperatures");
        System.out.print("\n6. Create DPCM request song");
        System.out.print("\n7. Create DPCM request freq");
        System.out.print("\n8. Create AQDPCM request song");
        System.out.print("\n9. Create AQDPCM request freq");
        // get user choice
        userChoice = Integer.parseInt(scanner.nextLine());
        // apply
        if (userChoice == 1 || userChoice == 2) {
            try {
                echo(echo_code_delay, userChoice, serverPort, clientPort);
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else if (userChoice == 3 || userChoice == 4) {
            try {
                image(image_code, userChoice, serverPort, clientPort);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        else if (userChoice == 5){
            try {
                temperatures(echo_code_delay, serverPort, clientPort);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        else if(userChoice == 8 || userChoice == 9){
            try{
                soundAQDPCM(sound_code,userChoice,serverPort,clientPort);
            } catch (SocketException e) {
                e.printStackTrace();
            } catch (UnknownHostException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } catch (LineUnavailableException e) {
                e.printStackTrace();
            }
        }
        else if (userChoice == 10){
            try {
                Ithakicopter(copter_code,serverPort,clientPort);
            } catch (IOException e) {
                e.printStackTrace();
            } catch (LineUnavailableException e) {
                e.printStackTrace();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }
        }

    }

    public static void echo(int echo_code, int echo_case, int serverPort, int clientPort) throws SocketException, IOException, UnknownHostException {
        // used to print echo packet messages
        String echo_message = "";
        // gives the correct name to output files for both cases
        String chosen_mode = "";
        // echo packet code from the session
        String code = "";
        switch (echo_case){
            case 1:
                chosen_mode = "case_delay";
                code = "E" + Integer.toString(echo_code) + "\r";
                break;
            case 2:
                chosen_mode = "case_without_delay";
                code = "E0000\r";
                break;
        }
        //init InetAddress
        byte[] hostIP = {(byte) 155, (byte) 207, 18, (byte) 208};
        InetAddress hostAddress = InetAddress.getByAddress(hostIP);
        // getArray of bytes
        byte[] code_byte = code.getBytes();
        // init DatagramSocket
        DatagramSocket sendSocket = new DatagramSocket();
        DatagramPacket sendPacket = new DatagramPacket(code_byte, code_byte.length, hostAddress, serverPort);
        DatagramSocket recieveSocket = new DatagramSocket(clientPort);
        recieveSocket.setSoTimeout(3600);
        // init arrayOf bytes
        byte[] recieve_byte = new byte[2048];
        DatagramPacket recievePacket = new DatagramPacket(recieve_byte, recieve_byte.length);
        // time of packets will be saved here
        ArrayList<Double> arrayList_timePacket = new ArrayList<Double>();
        // we will count all packets recieved
        int packet_counter = 0;
        // time variables
        double timeElapsed = 0;
        double averageTime = 0;
        double beginSession = 0;
        double endSession = 0;
        double beginTime = 0;
        double endTime = 0;
        // get current time
        beginSession = System.nanoTime();
        // set time for recieving packets
        int five_minutes_session = 5 * 60 * 1000;
        // results of session will be saved here
        ArrayList<String> arrayList_output = new ArrayList<String>();
        // begin loop
        while (endSession < five_minutes_session) {
            //sending one packet
            sendSocket.send(sendPacket);
            // update time
            beginTime = System.nanoTime();
            // increase counter
            packet_counter++;
            for (; ; ) {
                try {
                    // recieve packet
                    recieveSocket.receive(recievePacket);
                    // update end time
                    endTime = (System.nanoTime() - beginTime) / 1000000;
                    // print message
                    echo_message = new String(recieve_byte, 0, recievePacket.getLength());
                    System.out.println(echo_message);
                    // print time response
                    System.out.print("" + endTime + "\n");
                    break;
                } catch (Exception x) {
                    System.out.println(x);
                    break;
                }
            }
            // update time elapsed
            timeElapsed += endTime;
            // add endTime
            arrayList_timePacket.add(endTime);
            // update ArrayList for output file
            arrayList_output.add("" + endTime);
            // update endSession
            endSession = (System.nanoTime() - beginSession) / 1000000;
        }
        // some handy statistics for our report
        ArrayList<String> arrayList_stats = new ArrayList<String>();
        // average time
        averageTime = timeElapsed / packet_counter;
        arrayList_stats.add("Session time :" + (timeElapsed / 60) / 1000 + " minutes\n");
        arrayList_stats.add("Total time : " + (endSession / 60) / 1000 + " minutes\n");
        arrayList_stats.add("Total number of packets : " + String.valueOf((double) packet_counter));
        arrayList_stats.add("Total average time : " + String.valueOf(averageTime));
        double sum = 0;
        float counter = 0;
        ArrayList<Float> counters = new ArrayList<Float>();
        for (int i = 0; i < arrayList_timePacket.size(); i++) {
            int j = i;
            while ((sum < 8 * 1000) && (j < arrayList_timePacket.size())) {
                sum += arrayList_timePacket.get(j);
                counter++;
                j++;
            }
            counter = counter / 8;
            counters.add(counter);
            counter = 0;
            sum = 0;
        }
        // create output file
        BufferedWriter bufferedWriter = null;
        try {
            String fileDestination = "Echo_" + echo_code + "_" + chosen_mode + ".txt";
            File file = new File(fileDestination);
            bufferedWriter = new BufferedWriter(new FileWriter(fileDestination, false));
            if (!file.exists()) {
                file.createNewFile();
            }
            for (int i = 0; i < arrayList_output.size(); i++) {

                bufferedWriter.write(String.valueOf(arrayList_output.get(i)));
                bufferedWriter.newLine();
            }
            bufferedWriter.newLine();
        } catch (IOException ioe) {
            ioe.printStackTrace();
        } finally {
            try {
                if (bufferedWriter != null) bufferedWriter.close();
            } catch (Exception ex) {
                System.out.println("Error in closing the BufferedWriter" + ex);
            }
        }

        bufferedWriter = null;

        try {
            String fileDestination = "Echo_Statistics_" + echo_code + "_" + chosen_mode + ".txt";
            File file = new File(fileDestination);
            bufferedWriter = new BufferedWriter(new FileWriter(fileDestination, false));
            if (!file.exists()) {
                file.createNewFile();
            }
            for (int i = 0; i < arrayList_stats.size(); i++) {
                bufferedWriter.write(String.valueOf(arrayList_stats.get(i)));
                bufferedWriter.newLine();
            }
            bufferedWriter.newLine();
        } catch (IOException ioe) {
            ioe.printStackTrace();
        } finally {
            try {
                if (bufferedWriter != null) bufferedWriter.close();
            } catch (Exception ex) {
                //TODO
            }
        }

        bufferedWriter = null;

        try {
            String finalDestination = "Echo_R_" + echo_code + "_" + chosen_mode + ".txt";
            File file = new File(finalDestination);
            bufferedWriter = new BufferedWriter(new FileWriter(finalDestination, false));
            if (!file.exists()) {
                file.createNewFile();
            }
            for (int i = 0; i < counters.size(); i++) {
                bufferedWriter.write(String.valueOf(counters.get(i)));
                bufferedWriter.newLine();
            }
            bufferedWriter.newLine();
        } catch (IOException ioe) {
            ioe.printStackTrace();
        } finally {
            try {
                if (bufferedWriter != null) bufferedWriter.close();
            } catch (Exception ex) {
                //TODO
            }
        }
        recieveSocket.close();
        sendSocket.close();

    }


    public static void image(int code, int case_image, int server_listening_port, int client_listening_port) throws SocketException, IOException, UnknownHostException {
        // update image code based on every case
        String image_code = "";
        // update title for file
        String title_case = "";
        switch (case_image){
            case 3:
                title_case = "CAMERA_1";
                image_code = "M" + Integer.toString(code) + "\r";
                break;
            case 4:
                title_case = "CAMERA_2";
                image_code = "M" + Integer.toString(code) + " " + "CAM=PTZ" + "\r";
                break;
        }
        // initialize InetAddress
        byte[] hostIP = {(byte) 155, (byte) 207, 18, (byte) 208};
        InetAddress hostAddress = InetAddress.getByAddress(hostIP);
        // array of bytes
        byte[] code_array = image_code.getBytes();
        // initialize DatagramSocket
        DatagramSocket sendSocket = new DatagramSocket();
        DatagramPacket sendPacket = new DatagramPacket(code_array, code_array.length, hostAddress, server_listening_port);
        DatagramSocket recieveSocket = new DatagramSocket(client_listening_port);
        recieveSocket.setSoTimeout(3600);
        // array of bytes
        byte[] byte_recieve_array = new byte[2048];
        DatagramPacket recievePacket = new DatagramPacket(byte_recieve_array, byte_recieve_array.length);
        sendSocket.send(sendPacket);
        // set Timeout
        recieveSocket.setSoTimeout(3200);
        // output file name
        String outputName = ("image" + code + title_case + ".jpeg");
        // initialize File-Output-Stream
        FileOutputStream fOS = new FileOutputStream(outputName);
        for (; ; ) {
            try {
                // receiving packets
                recieveSocket.receive(recievePacket);
                if (byte_recieve_array == null) break;
                for (int i = 0; i <= 127; i++) {
                    fOS.write(byte_recieve_array[i]);
                }
            } catch (IOException ex) {
                System.out.println(ex);
                break;
            }
        }
        fOS.close();
        recieveSocket.close();
        sendSocket.close();
    }

    public static void temperatures(int echoCode, int server_listening_port, int client_listening_port) throws SocketException, IOException, UnknownHostException {
        String packetInfo = "";
        String code = "E" + Integer.toString(echoCode) + "\r";
        byte[] hostIP = {(byte) 155, (byte) 207, 18, (byte) 208};
        InetAddress hostAddress = InetAddress.getByAddress(hostIP);
        // getArray of bytes
        byte[] code_byte = code.getBytes();
        // init DatagramSocket
        DatagramSocket sendSocket = new DatagramSocket();
        DatagramPacket sendPacket = new DatagramPacket(code_byte, code_byte.length, hostAddress, server_listening_port);
        DatagramSocket recieveSocket = new DatagramSocket(client_listening_port);
        recieveSocket.setSoTimeout(3600);
        // init arrayOf bytes
        byte[] recieve_byte = new byte[2048];
        DatagramPacket recievePacket = new DatagramPacket(recieve_byte, recieve_byte.length);
        // time of packets will be saved here
        ArrayList<Double> arrayList_timePacket = new ArrayList<Double>();
        // we will count all packets recieved
        int packet_counter = 0;
        // time variables
        double timeElapsed = 0;
        double averageTime = 0;
        double beginSession = 0;
        double endSession = 0;
        double beginTime = 0;
        double endTime = 0;
        // get current time
        beginSession = System.nanoTime();
        int numberOfPackets = 0;
        String message = "";
        beginSession = System.nanoTime();
        for (int i = 0; i <= 9; i++) {
            packetInfo = "E" + Integer.toString(echoCode) + "T0" + i + "\r";
            code_byte = packetInfo.getBytes();
            sendPacket = new DatagramPacket(code_byte, code_byte.length, hostAddress, server_listening_port);
            sendSocket.send(sendPacket);
            numberOfPackets++;
            beginTime = System.nanoTime();
            for (; ; ) {
                try {
                    recieveSocket.receive(recievePacket);
                    endTime = (System.nanoTime() - beginTime) / 1000000;
                    message = new String(recieve_byte, 0, recievePacket.getLength());
                    System.out.println(message);
                    System.out.print("" + endTime + "\n");
                    break;
                } catch (Exception x) {
                    System.out.println(x);
                    break;
                }
            }
            timeElapsed += endTime;
            endSession = (System.nanoTime() - beginSession) / 1000000;

        }

    }



    public static void soundAQDPCM(int audioCode,int mode,int serverPort,int clientPort) throws SocketException,IOException,UnknownHostException,LineUnavailableException{
        int numPackets = 999,mask1 = 15,mask2 = 240,rx;
        int soundSample1 = 0,soundSample2 = 0;
        int nibble1,nibble2,sub1,sub2,x1 = 0,x2 = 0,counter = 4,mean,b,temp = 0;
        String message = "",packetInfo = "",modeinfo="";
        ArrayList<Integer> means = new ArrayList<Integer>();
        ArrayList<Integer> bs = new ArrayList<Integer>();
        ArrayList<Integer> subs = new ArrayList<Integer>();
        ArrayList<Integer> samples = new ArrayList<Integer>();


        switch (mode){
            case 8:
                modeinfo="song";
                packetInfo = "A" + Integer.toString(audioCode) + "AQF999";
                break;
            case 9:
                modeinfo="freq";
                packetInfo = "A" + Integer.toString(audioCode) + "AQT999";
                break;
        }



        byte[] hostIP = { (byte)155,(byte)207,18,(byte)208 };
        InetAddress hostAddress = InetAddress.getByAddress(hostIP);

        byte[] txbuffer = packetInfo.getBytes();

        DatagramSocket sendSocket = new DatagramSocket();
        DatagramPacket sendPacket = new DatagramPacket(txbuffer,txbuffer.length, hostAddress,serverPort);

        DatagramSocket recieveSocket = new DatagramSocket(clientPort);

        byte[] rxbuffer = new byte[132];
        DatagramPacket recievePacket = new DatagramPacket(rxbuffer,rxbuffer.length);
        recieveSocket.setSoTimeout(5000);
        sendSocket.send(sendPacket);
        byte[] meanByte = new byte[4];
        byte[] bByte = new byte[4];
        byte sign;
        byte[] song = new byte[256*2*numPackets];
        for(int i = 1;i < numPackets;i++){
            if((i%100)==0){
                System.out.println((1000-i)+" samples left");
            }

            try{
                recieveSocket.receive(recievePacket);
                sign = (byte)( ( rxbuffer[1] & 0x80) !=0 ? 0xff : 0x00);//if rxbuffer[1]&10000000=0 then sign =0 else =01111111 , we take the compliment of this number
                meanByte[3] = sign;
                meanByte[2] = sign;
                meanByte[1] = rxbuffer[1];
                meanByte[0] = rxbuffer[0];
                mean = ByteBuffer.wrap(meanByte).order(ByteOrder.LITTLE_ENDIAN).getInt(); //convert the array into integer number using LITTLE_ENDIAN format
                means.add(mean);
                sign = (byte)( ( rxbuffer[3] & 0x80) !=0 ? 0xff : 0x00);
                bByte[3] = sign;
                bByte[2] = sign;
                bByte[1] = rxbuffer[3];
                bByte[0] = rxbuffer[2];
                b = ByteBuffer.wrap(bByte).order(ByteOrder.LITTLE_ENDIAN).getInt();
                bs.add(b);

                for (int j = 4;j <= 131;j++){ //the remaining bytes are the samples
                    rx = rxbuffer[j];
                    nibble1 = (int)(rx & 0x0000000F);
                    nibble2 = (int)((rxbuffer[j] & 0x000000F0)>>4);
                    sub1 = (nibble2-8);
                    subs.add(sub1);
                    sub2 = (nibble1-8);
                    subs.add(sub2);
                    sub1 = sub1*b;
                    sub2 = sub2*b;
                    x1 = temp + sub1 + mean;
                    samples.add(x1);
                    x2 = sub1 + sub2 + mean;
                    temp = sub2;
                    samples.add(x2);
                    counter += 4;
                    song[counter] = (byte)(x1 & 0x000000FF);
                    song[counter + 1] = (byte)((x1 & 0x0000FF00)>>8);
                    song[counter + 2] = (byte)(x2 & 0x000000FF);
                    song[counter + 3] = (byte)((x2 & 0x0000FF00)>>8);


                }
            }catch (Exception ex){
                System.out.println(ex);
            }
        }
        if(mode==1){
            System.out.println("Playing the song");

            AudioFormat aqpcm = new AudioFormat(8000,16,1,true,false);
            SourceDataLine playsong = AudioSystem.getSourceDataLine(aqpcm);
            playsong.open(aqpcm,32000);
            playsong.start();
            playsong.write(song,0,256*2*numPackets);
            playsong.stop();
            playsong.close();
        }


        BufferedWriter bw = null;
        try{
            File file = new File("AQDPCMsubsF"+audioCode+modeinfo+".txt");
            if(!file.exists()){
                file.createNewFile();
            }
            FileWriter fw = new FileWriter(file,false);
            bw = new BufferedWriter(fw);
            for(int i = 0 ; i < subs.size() ; i += 2){
                bw.write("" + subs.get(i) + " " + subs.get(i+1));
                bw.newLine();
            }

        }catch(IOException ioe){
            ioe.printStackTrace();
        }finally{
            try{
                if(bw != null) bw.close();
            }catch(Exception ex){
                System.out.println("Error in closing the BufferedWriter" + ex);
            }
        }

        BufferedWriter mw = null;
        try{
            File file = new File("AQDPCMsamplesF"+audioCode+modeinfo+".txt");
            if(!file.exists()){
                file.createNewFile();
            }
            FileWriter fw = new FileWriter(file,false);
            mw = new BufferedWriter(fw);
            for(int i = 0 ; i < samples.size() ; i += 2){
                mw.write("" + samples.get(i) + " " + samples.get(i+1));
                mw.newLine();
            }

        }catch(IOException ioe){
            ioe.printStackTrace();
        }finally{
            try{
                if(mw != null) mw.close();
            }catch(Exception ex){
                System.out.println("Error in closing the BufferedWriter" + ex);
            }
        }

        BufferedWriter pw = null;
        try{
            File file = new File("AQDPCMmeanF"+audioCode+modeinfo+".txt");
            if(!file.exists()){
                file.createNewFile();
            }
            FileWriter fw = new FileWriter(file,false);
            pw = new BufferedWriter(fw);
            for(int i = 0 ; i < means.size() ; i += 2){
                pw.write("" + means.get(i));
                pw.newLine();
            }

        }catch(IOException ioe){
            ioe.printStackTrace();
        }finally{
            try{
                if(pw != null) pw.close();
            }catch(Exception ex){
                System.out.println("Error in closing the BufferedWriter" + ex);
            }
        }

        BufferedWriter kw = null;
        try{
            File file = new File("AQDPCMbetasF"+audioCode+modeinfo+".txt");
            if(!file.exists()){
                file.createNewFile();
            }
            FileWriter fw = new FileWriter(file,false);
            kw = new BufferedWriter(fw);
            for(int i = 0 ; i < bs.size() ; i ++){
                kw.write("" + bs.get(i));
                kw.newLine();
            }

        }catch(IOException ioe){
            ioe.printStackTrace();
        }finally{
            try{
                if(kw != null) kw.close();
            }catch(Exception ex){
                System.out.println("Error in closing the BufferedWriter" + ex);
            }
        }

        recieveSocket.close();
        sendSocket.close();

    }



    public static void Ithakicopter(int copterCode, int serverPort, int clientPort) throws SocketException,IOException,UnknownHostException,LineUnavailableException,ClassNotFoundException{
        String packetInfo="",message="";
        ArrayList<String> messages = new ArrayList<String>();

        packetInfo = "Q" + Integer.toString(copterCode)+"\r";
        byte[] hostIP = { (byte)155,(byte)207,18,(byte)208 };
        InetAddress hostAddress = InetAddress.getByAddress(hostIP);
        byte[] txbuffer = packetInfo.getBytes();
        DatagramSocket sendSocket = new DatagramSocket();
        DatagramPacket sendPacket = new DatagramPacket(txbuffer,txbuffer.length, hostAddress,serverPort);
        DatagramSocket recieveSocket = new DatagramSocket(clientPort);
        byte[] rxbuffer = new byte[5000];
        DatagramPacket recievePacket = new DatagramPacket(rxbuffer,rxbuffer.length);
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        messages.add("Current Session "+copterCode+" Current Time "+sdf.format(cal.getTime())+"\n");
        recieveSocket.setSoTimeout(5000);
        for (int i = 1;i <= 60 ; i++){
            try{
                sendSocket.send(sendPacket);
                recieveSocket.receive(recievePacket);
                message = new String(rxbuffer,0,recievePacket.getLength());
                messages.add(message);
                System.out.println(message);
            }catch(Exception ex){
                System.out.println(ex);
            }

        }

        BufferedWriter bw = null;
        try{
            File file = new File("Ithakicopter"+copterCode+".txt");
            if(!file.exists()){
                file.createNewFile();
            }
            FileWriter fw = new FileWriter(file,true);
            bw = new BufferedWriter(fw);
            for(int i = 0 ; i < messages.size(); i++){
                bw.write("" + messages.get(i));
                bw.newLine();
            }

        }catch(IOException ioe){
            ioe.printStackTrace();
        }finally{
            try{
                if(bw != null) bw.close();
            }catch(Exception ex){
                System.out.println("Error in closing the BufferedWriter" + ex);
            }
        }

        recieveSocket.close();
        sendSocket.close();
    }

}