import java.rmi.*;

public interface Adder extends Remote{
public int add(int x,int y)throws
RemoteException;
}

public class AdderRemote extends
UnicastRemoteObject implements Adder{
AdderRemote()throws RemoteException{
super();
}
public int add(int x,int y){return x+y;}




public static void main(String args[]){
try{
Adder ob=new AdderRemote();
Naming.rebind("rmi://localhost:6000/Biju",ob);
}catch(Exception e){System.out.println(e);}





client

import java.rmi.*;
public class MyClient{
public static void main(String args[]){
try{
Adder
stub=(Adder)Naming.lookup("rmi://localhost:6000/Bij
u");
System.out.println(stub.add(34,4));
}catch(Exception e){}
}
