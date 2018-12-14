import java.util.Map;
//Constructor template for ConstantExp1:
//new ConstantExp1(val);
//INTERPRETATION:
//val is of type ExpVal and it specifies the value of this constant expression


public class ConstantExp1 extends Exp1 implements ConstantExp {
	
	private ExpVal val;
	
	ConstantExp1() // non parameterized constructor
	{
		val = new ExpVal1(); // creates a new ExpVal object and assigns to val
		
	}
	
	ConstantExp1(ExpVal v) // parameterized constructor
	{
		
	  this.val = v;	
	}
	
	//----------------------------------------------------------------------------------------
	
	// RETURNS: the value of this constant expression.
	// EXAMPLE: Asts.constantExp (Asts.expVal (1)).value() 
	//                                    = Asts.expVal (1)

	public ExpVal value() {
		
		return this.val;
	}
	
	//------------------------------------------------------------------------------------------
	
	@Override
	
	// RETURNS: a boolean value that is true or false, as the function is called on 
	//          an constant expression object,the function returns true
	// EXAMPLE: obj.isConstant() = true
	//          where obj is a constant expression object

	public boolean isConstant () {
		return true;
	}
	
	//-------------------------------------------------------------------------------------------
	
	@Override 
	
	// RETURNS: an ConstantExp object, the representation of the constant expression
	//          object is returned
	// EXAMPLE: obj.asConstant() = obj
	//          obj is an constant expression object

	 public ConstantExp asConstant()
	{
		return this;
	}
	
	//---------------------------------------------------------------------------------------------
	
	@Overidden
	
	// GIVEN: a Map<String,ExpVal>, which is the environment for a constant expression
	// RETURNS: the ExpVal of the constant expression
	
	public ExpVal value (Map<String,ExpVal> env)
    {
		ExpVal result = new ExpVal1();
    
		try
		{
        result = this.val;
        }
		catch(NullPointerException n)
    	{
    	 System.out.println("Constant Expression : Warning : Variable of this expression is not a key of the given Map");	
    	}
		
		
			return result;
		
    }
	
	//----------------------------------------------------------------------------------------------------

}
