import java.util.Map;

//Constructor template for IfExp1:
//new IfExp1(testP,thenP,elseP);
//Interpretation:
//testP is of type Exp and specifies the test part of the if expression
//thenP is of type Exp and specifies the then part of the if expression
//elseP is of type Exp and specifies the else part of the if expression


public class IfExp1 extends Exp1 implements IfExp{

	private Exp testP; //test expression of this if expression
	private Exp thenP; //then expression of this if expression
	private Exp elseP; //else expression of this if expression

	IfExp1() // non parameterized constructor
	{

	}

	IfExp1(Exp tst, Exp thn, Exp els) // parameterized constructor
	{
		this.testP = tst;
		this.thenP = thn;
		this.elseP = els;
	}

	//----------------------------------------------------------------------------------------
	//                      MEMBER FUNCTIONS
	//------------------------------------------------------------------------------------------

	@Override

	// RETURNS: a boolean value that is true or false, as the function is called on 
	//          an if expression(IfExp) object,the function returns true
	// EXAMPLE: obj.isIf() = true
	//          where obj is an if expression(IfExp) object

	public boolean isIf()
	{
		return true;
	}

	//-------------------------------------------------------------------------------------------

	@Override

	// RETURNS: an IfExp, the representation of the If expression
	//          object is returned
	// EXAMPLE: obj.asIf() = obj
	//          obj is an if expression(IfExp) object

	public IfExp asIf()
	{
		return this;
	}

	//------------------------------------------------------------------------------------------


	// RETURNS: the test part of an if expression(IfExp)
	// EXAMPLE:
	/* Exp testPart
	            = Asts.arithmeticExp (Asts.identifierExp ("n"),
	                                  "EQ",
	                                  Asts.constantExp (Asts.expVal (0)));
	        Exp thenPart
	            = Asts.constantExp (Asts.expVal (1));
	        Exp elsePart
	            = Asts.arithmeticExp (Asts.identifierExp ("n"),
	                                  "TIMES",
	                                  call1);
	       Asts.ifExp (testPart,thenPart,elsePart).testPart() = testPart */

	public Exp testPart()
	{
		return this.testP;
	}

	//----------------------------------------------------------------------------------------------------


	// RETURNS: the then part of an if expression(IfExp)
	// EXAMPLE:
	/* Exp testPart
		            = Asts.arithmeticExp (Asts.identifierExp ("n"),
		                                  "EQ",
		                                  Asts.constantExp (Asts.expVal (0)));
		        Exp thenPart
		            = Asts.constantExp (Asts.expVal (1));
		        Exp elsePart
		            = Asts.arithmeticExp (Asts.identifierExp ("n"),
		                                  "TIMES",
		                                  call1);
		       Asts.ifExp (testPart,thenPart,elsePart).thenPart() = thenPart */
	public Exp thenPart()
	{
		return this.thenP;
	}


	//---------------------------------------------------------------------------------------------------

	// RETURNS: the else part of an if expression(IfExp)
	// EXAMPLE:
	/* Exp testPart
 	            = Asts.arithmeticExp (Asts.identifierExp ("n"),
 	                                  "EQ",
 	                                  Asts.constantExp (Asts.expVal (0)));
 	        Exp thenPart
 	            = Asts.constantExp (Asts.expVal (1));
 	        Exp elsePart
 	            = Asts.arithmeticExp (Asts.identifierExp ("n"),
 	                                  "TIMES",
 	                                  call1);
 	       Asts.ifExp (testPart,thenPart,elsePart).elsePart() = elsePart */
	public Exp elsePart()

	{
		return this.elseP;
	}

	//------------------------------------------------------------------------------------------------

	// GIVEN: a Map<String,ExpVal>, which is the environment for an if expression
	// RETURNS: a ExpVal,returns the corresponding components of the if expression,
	//          that is, the test part or then part or the else part.
	public ExpVal value (Map<String,ExpVal> env)
	{

		ExpVal etest = new ExpVal1();
		ExpVal ethen = new ExpVal1();
		ExpVal eelse = new ExpVal1();
		ExpVal result = new ExpVal1();
		Boolean b;

		try
		{
			
			etest = this.testP.value(env);



			if(etest.isBoolean())
			{
				b = etest.asBoolean();

				if(b)
				{
					
					ethen = this.thenP.value(env);
					result = ethen;
				}
				else
				{
					
					eelse = this.elseP.value(env);
					result = eelse;
				}
			}

		}
		catch(NullPointerException n)
		{
			System.out.println("If Expression : Warning : Variable of this expression is not a key of the given Map");	
		}
		catch(Exception e1)
		{
			System.out.println("Warning: Exception thrown!");
		}
		
			return result;
		
	}

	//------------------------------------------------------------------------------------------------
}
