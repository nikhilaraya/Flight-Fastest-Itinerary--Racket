import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

// Programs file implements the following methods : 
// 1. run method which implements the functionality of interpreter
// 2. undefined method which returns the set of all variable names that occur free within the program
// 3. a main method which Runs the ps11 program found in the file named on the command line
//    on the integer inputs that follow its name on the command line,
//    printing the result computed by the program.

public class Programs extends Ast1 {
	
	//-----------------------------------------------------------------------------------------------
	//                                MEMBER FUNCTIONS
	//-----------------------------------------------------------------------------------------------

	//GIVEN : A list of definitions and a list of input to the definitions
	//RETURNS : The ExpVal after computing those definitions for given input
	//DESIGN STRATEGY : Combine simpler functions

	public static ExpVal run (List<Def> pgm, List<ExpVal> inputs) 
	{
		Map<String, ExpVal> env = new HashMap<String, ExpVal>();
		
		for(int i =0; i < pgm.size(); i++)
		{
			env.put(pgm.get(i).lhs(), pgm.get(i).rhs().value(env));
		}
		
		List<Exp> operands = new ArrayList<Exp>();
		
		for ( ExpVal ev : inputs) 
		{
			
			operands.add(Asts.constantExp(ev));
		}
		
		CallExp cexp = Asts.callExp(Asts.identifierExp(pgm.get(0).lhs()), operands);
			   			
		return cexp.value(env);

	}
	
	//----------------------------------------------------------------------------------------------
	//----------------------------------------------------------------------------------------------
	
	// Runs the ps11 program found in the file named on the command line
    // on the integer inputs that follow its name on the command line,
    // printing the result computed by the program.
    //
    // Example:
    //
    //     % java Programs sieve.ps11 2 100
    //     25
	// Design strategy : Combine simpler functions
	
	public static void main (String[] args)
	{
		Scanner.printResult(args);
	}
	
	//-----------------------------------------------------------------------------------------------
	//-----------------------------------------------------------------------------------------------
	
	// Reads the ps11 program found in the file named by the given string
    // and returns the set of all variable names that occur free within
    // the program.
    //
    // Examples:
    //     Programs.undefined ("church.ps11")    // returns an empty set
    //     Programs.undefined ("bad.ps11")       // returns { "x", "z" }
    //
    //   where bad.ps11 is a file containing:
    // 
    //     f (x, y) g (x, y) (y, z);
    //     g (z, y) if 3 > 4 then x else f
    // Design Strategy : Combine simpler functions
	
	public static Set<String> undefined (String filename) {
   	 String pgm = Scanner.readPgm(filename);
   	 List<Def> lod= Scanner.parsePgm(pgm);
   	 
   	 Set<String> listOfFunctionNames =new HashSet<String>();
   	 Set<String> listOfVariablesNames =new HashSet<String>();
   	 Set<String> undefinedVariablesNames =new HashSet<String>();
   	 
   	 for(int i=0;i<lod.size();i++)
   	 {
   		 listOfFunctionNames.add(lod.get(i).lhs());
   	 }
   	 for(int i=0;i<lod.size();i++)
   	 {
   		if(lod.get(i).rhs().isConstant())
   		continue;
   		else
   		{
   			listOfVariablesNames.clear();
   			
   			listOfVariablesNames.addAll(listOfFunctionNames);
   			
   			LambdaExp e=lod.get(i).rhs().asLambda();
   			
   			listOfVariablesNames.addAll(e.formals());
   		    
   		    undefinedVariablesNames.addAll(getVariablesForExp(listOfVariablesNames,e.body()));
   		}
   		 
   	 }	 
   	return undefinedVariablesNames;
   }
	
	//------------------------------------------------------------------------------------------
	//-----------------------------------------------------------------------------------------
	
	// GIVEN : A set of string and an expression
	// WHERE : The set of strings refers to the set of defined variable names
	// RETURNS : A set of undefined variable names
	// DESIGN STRATEGY : Combine simpler functions
   
   public static Set<String> getVariablesForExp(Set<String> s,Exp e){
   	Set<String> loundefined =new HashSet<String>();
   	if(e.isArithmetic())
   	{
   		ArithmeticExp ae=e.asArithmetic();
   		loundefined.addAll(getVariablesForExp(s,ae.leftOperand()));
   		loundefined.addAll(getVariablesForExp(s,ae.rightOperand()));
   		return loundefined;
   	}
   	else if(e.isIf())
   	{
   		IfExp ie=e.asIf();
   		loundefined.addAll(getVariablesForExp(s, ie.testPart()));
   		loundefined.addAll(getVariablesForExp(s, ie.thenPart()));
   		loundefined.addAll(getVariablesForExp(s, ie.elsePart()));
   		return loundefined;
   	}
   	else if(e.isLambda())
   	{
   		LambdaExp le=e.asLambda();
   		s.addAll(le.formals());
   		loundefined.addAll(getVariablesForExp(s, le.body()));
   		return loundefined;
   	}
   	else if(e.isIdentifier())
   	{
   		IdentifierExp id=e.asIdentifier();
   		if(s.contains(id.name()))
   		{
   			return loundefined;
   		}
   		else
   		{
   			loundefined.add(id.name());
   			return loundefined;
   		}
   	}
   	else if(e.isConstant())
   	{
   		return loundefined;		
   	}
   	else if(e.isCall()){
   		CallExp ce=e.asCall();
   		s.addAll(getVariablesForExp(s, ce.operator()));
   		
   		for(int i=0;i<ce.arguments().size();i++)
   		{
   			loundefined.addAll(getVariablesForExp(s,ce.arguments().get(i)));
   		}
   		return loundefined;
   	}
   	else
   	{
   		return loundefined;
   	}
   }
   
   //----------------------------------------------------------------------------------------------------
   //----------------------------------------------------------------------------------------------------

}







