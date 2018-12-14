import java.util.Map;
//Constructor template for FunVal1:
//new FunVal1(expression,environment);
//expression is of type LambdaExp and specifies the lambda expression from which this function was created
//environment is a Map and specifies the environment that maps the free variables of that
//lambda expression to their values

public class FunVal1 extends ExpVal1 implements FunVal{

	private LambdaExp expression; // specifies the LambdaExp for the function
	private Map<String,ExpVal> envi; // specifies the environment for a particular function
	FunVal1(){ // non parameterized constructor
		
	}
	FunVal1(LambdaExp ex,Map<String,ExpVal> env){ // parameterized constructor 
		
		this.expression=ex;
		this.envi=env;
	}
	
	//----------------------------------------------------------------------------------------
	//                              MEMBER FUNCTIIONS
	//--------------------------------------------------------------------------------------------
	
	@Override
	
	// RETURNS: a boolean value that is true or false, as the function is called on 
	//          a FunVal object,the function returns true
	// EXAMPLE: obj.isConstant() = true
	//          where obj is a FunVal object
	
	public boolean isFunction()
	{
		return true;
	}
	
	//-----------------------------------------------------------------------------------------
	
	@Override
	
	// RETURNS: a FunVal value, the representation of the FunVal type is returned
	// EXAMPLE: obj.asFunction() = obj 
	//          where obj is an FunVal object
	
	public FunVal asFunction() {
		return this;
	}
	
	//-----------------------------------------------------------------------------------------

	// RETURNS: the lambda expression from which this function was created.
	// EXAMPLE: Def def1
	    //              = Asts.def ("fact",
	    //                          Asts.lambdaExp (Asts.list ("n"),
	    //                                          Asts.ifExp (testPart,
	    //                                                      thenPart,
	    //                                                      elsePart)))
		//         def1.code() = Asts.lambdaExp (Asts.list ("n"),
	    //                                          Asts.ifExp (testPart,
	    //                                                      thenPart,
	    //                                                      elsePart)
	
	public LambdaExp code() {
		return this.expression;
	}
	
	//-----------------------------------------------------------------------------------------
	
	// RETURNS: the environment that maps the free variables of that
    //          lambda expression to their values.
	public Map<String, ExpVal> environment() {
		return this.envi;
	}
	
	//--------------------------------------------------------------------------------------------

}
