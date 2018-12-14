import java.util.ArrayList;
import java.util.List;
import java.util.Map;
//Constructor template for LambdaExp1:
//new LambdaExp1(los,expression);
//INTERPRETATION:
//los is a list of type strings which specifies the formal 
//parameters of this lambda expression
//expression is of type Exp which specifies the body of this lambda expression.


public class LambdaExp1 extends Exp1 implements LambdaExp{
	
	private List<String> los;
	private Exp expression;
	
	LambdaExp1(){
		
	}
	LambdaExp1(List<String> formal,Exp e){
		
		this.los=formal; //the formal parameters of this lambda expression
		this.expression=e; //the body of this lambda expression
	}
	
	//---------------------------------------------------------------------------------------
	//                    MEMBER FUNCTIONS
	//----------------------------------------------------------------------------------------
	
	@Override
	
	// RETURNS: a boolean value that is true or false, as the function is called on 
	//          an Lambda expression object,the function returns true
	// EXAMPLE: obj.isLambda() = true
	//          where obj is an Lambda expression object
	
	public boolean isLambda()
	{
		return true;
	}
	
	//--------------------------------------------------------------------------------------------
	
	@Override
	// RETURNS: an LambdaExp, the representation of the Lambda expression
	//          object is returned
	// EXAMPLE: obj.asLambda() = obj
	//          obj is an lambda expression object

	public LambdaExp asLambda()
	{
		
		return this;
	}
	
	//--------------------------------------------------------------------------------------------
	  
	// RETURNS: Returns the formal parameters of this lambda expression.
    // EXAMPLE: LambdaExp l=Asts.lambdaExp (Asts.list ("n"),
    //                                     Asts.ifExp (testPart,
    //                                     thenPart,
    //                                     elsePart)));
	//         List<String> los= new ArrayList<String>();
	//         los.add("n");
	//         l.formals() =  los

    public List<String> formals(){
    	
    	return this.los;
    }
    
    //-----------------------------------------------------------------------------------------------

    // RETURNS: Returns the body of this lambda expression.
    // EXAMPLE: LambdaExp l=Asts.lambdaExp (Asts.list ("n"),
    //                                     Asts.ifExp (testPart,
    //                                     thenPart,
    //                                     elsePart)));
    //         l.body() = Asts.ifExp (testPart,
    //                                     thenPart,
    //                                     elsePart)
 

    public Exp body(){
    	return this.expression;
    }
    
    //-----------------------------------------------------------------------------------------------
    
    // GIVEN: a Map<String,ExpVal>, which is the environment for a lambda expression
 	// RETURNS: an ExpVal, returns the value of the body expression in the corresponding 
 	//          lambda expression
    public ExpVal value (Map<String,ExpVal> env)
    {
    	FunVal f = new FunVal1();
    	
    	
    	try
    	{
    	
    		 f = new FunVal1 (this,env);
    	
    	}
    	catch(NullPointerException n)
    	{
    		System.out.println("LambdaExpression : Warning : Variable of this expression is not a key of the given Map");	
    	}
    	catch(Exception e1)
    	{
    		System.out.println("Warning: Exception thrown!");
    	}
    	return f;
    }
    
    //----------------------------------------------------------------------------------------------------

}
