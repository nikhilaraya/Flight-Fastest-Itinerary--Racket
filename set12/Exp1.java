import java.util.Map;

//Constructor template for Exp1:
//new Exp1(exp);
//INTERPRETATION:
//exp can be of type ConstantExp or IdentifierExp or LambdaExp or ArithmeticExp 
//or CallExp or IfExp.exp represents an expression of a source program. 

public class Exp1 extends Ast1 implements Exp {
	
	

	
	Exp1() //non-parameterized constructor
	{
		
	}
	
	
	//------------------------------------------------------------------------------------
	//                    MEMBER FUNCTIONS
	//------------------------------------------------------------------------------
	
	@Override
	
	// RETURNS: a boolean value that is true or false, as the function is called on 
	//          an expression object,the function returns true
	// EXAMPLE: obj.isExp() = true
	//          where obj is a Exp object

	public boolean isExp(){
		return true;
	}
	
	//-----------------------------------------------------------------------------------
	
	@Override
	// RETURNS: an Exp, the representation of the expression
	//          object is returned
	// EXAMPLE: obj.asExp() = obj
	//          obj is an Exp object

	public Exp asExp() {
		return this;
		
	}
	
	//---------------------------------------------------------------------------------
	
	// RETURNS: true iff this Exp is a constant expression.
	// EXAMPLE: Exp thenPart
	//            = Asts.constantExp (Asts.expVal (1));
	//          thenPart.isConstant() true
	// DESIGN STRATEGY: Breaking down into cases

    public boolean isConstant()
    {
    	 return false;
    }
    
    //---------------------------------------------------------------------------------------
    
 // RETURNS: true iff this Exp is a constant expression.
 // EXAMPLE: Exp thenPart
 //            = Asts.constantExp (Asts.expVal (1));
 //          thenPart.isConstant() = true
 // DESIGN STRATEGY: Breaking down into cases

    public boolean isIdentifier()
    {
    	 return false;
    }
  
    //------------------------------------------------------------------------------------
    
    
 // RETURNS: true iff this Exp is a Lambda expression.
 // EXAMPLE: Asts.lambdaExp (Asts.list ("n"),
 //                              Asts.ifExp (testPart,
 //                                          thenPart,
 //                                          elsePart)).isLambda = true
 // DESIGN STRATEGY: Breaking down into cases
  
    
    public boolean isLambda()
    {
    	return false;
    }
    
    //------------------------------------------------------------------------------------
    
 // RETURNS: true iff this Exp is a Arithmetic expression.
 // EXAMPLE: Exp elsePart
 //            = Asts.arithmeticExp (Asts.identifierExp ("n"),
 //                     "TIMES",
 //                     call1);
 //          elsePart.isArithmetic = true
 // DESIGN STRATEGY: Breaking down into cases

    
    public boolean isArithmetic()
    {
    	 return false;
    }
    
    //------------------------------------------------------------------------------------------
    
 // RETURNS: true iff this Exp is a call expression.
 // EXAMPLE:Exp call1
 //          = Asts.callExp (Asts.identifierExp ("fact"),
 //                                      Asts.list (exp1));
 //         call1.isCall() = true
 // DESIGN STRATEGY: Breaking down into cases

    public boolean isCall()
    {
    	return false;
    }
    
    //----------------------------------------------------------------------------------------------
    
 // RETURNS: true iff this Exp is an if expression.
 // EXAMPLE:Asts.ifExp (testPart,
 //                     thenPart,
 //                     elsePart).isIf() = true
 // DESIGN STRATEGY: Breaking down into cases

    public boolean isIf()
    {
    	 return false;
    }
    
    //---------------------------------------------------------------------------------------------

 // RETURNS: an ConstantExp object, the representation of the constant expression
 //          object is returned
 // EXAMPLE: obj.asConstant() = obj
 //          obj is an constant expression object

    public ConstantExp asConstant()
    {
    	return null;
    }
    
    //----------------------------------------------------------------------------------------------
    
 // RETURNS: an IdentifierExp object, the representation of the identifier expression
 //          object is returned
 // EXAMPLE: obj.asIdentifier() = obj
 //          obj is an identifier expression object

    public IdentifierExp asIdentifier()
    {
    	return null;
    }
    
    //------------------------------------------------------------------------------------------
    
 // RETURNS: an LambdaExp object, the representation of the lambda expression
 //          object is returned
 // EXAMPLE: obj.asLambda() = obj
 //          obj is an lambda expression object

    public LambdaExp asLambda()
    {
    	return null;
    }
    
    //---------------------------------------------------------------------------------------
    
 // RETURNS: an ArithmeticExp object, the representation of the arithmetic expression
 //          object is returned
 // EXAMPLE: obj.asArithmetic() = obj
 //          obj is an arithmetic expression object

    public ArithmeticExp asArithmetic()
    {
    	return null;
    }
    
    //-------------------------------------------------------------------------------------------
    
 // RETURNS: an CallExp object, the representation of the call expression
 //          object is returned
 // EXAMPLE: obj.asCall() = obj
 //          obj is an call expression object

    public CallExp asCall()
    {
    	return null;
    }
    
    //----------------------------------------------------------------------------------------------
    
 // RETURNS: an IfExp object, the representation of the if expression
 //          object is returned
 // EXAMPLE: obj.asIf() = obj
 //          obj is an if expression object

    public IfExp asIf()
    {
    	return null;
    }
    
    //-------------------------------------------------------------------------------------------------

    // GIVEN: a Map<String,ExpVal>, which is the environment for a expression
    // RETURNS: the value of this expression when its free variables
    //     have the values associated with them in the given Map.
    //     May run forever if this expression has no value.
    //     May throw a RuntimeException if some free variable of this
    //     expression is not a key of the given Map or if a type
    //     error is encountered during computation of the value.

    public ExpVal value (Map<String,ExpVal> env)
    {
    	
    	
    	
    	try
    	{
    	//
    	}
    	catch(NullPointerException n)
    	{
    	 System.out.println("Warning : Variable of this expression is not a key of the given Map");	
    	}
    	catch(Exception e1)
    	{
    		System.out.println("Warning: Exception thrown!");
    	}
    	
    	return null;
    	
    	
    }
    
    //----------------------------------------------------------------------------------------------


}
	