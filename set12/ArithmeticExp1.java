import java.util.Map;

//Constructor template for ArithematicExp1:
//new ArithematicExp1(lSide,o,rSide);
//INTERPRETATION:
//lSide is of type Exp and specifies the left hand side of the operator of an arithematic expression
//o is of type String and specifies the operator in an arithematic expression
//rSide is of type Exp and specifies the right hand side of the operator of an expression



public class ArithmeticExp1 extends Exp1 implements ArithmeticExp{

	private Exp left; // left side of the operator in an arithmetic expression
	private Exp right; // right side of the operator in an arithmetic expression
	private String operator; //specifies the operator in an arithmetic expression

	ArithmeticExp1(){ // non parameterized constructor

	}
	ArithmeticExp1(Exp lSide,String o,Exp rSide){ //parameterized constructor

		this.left=lSide;
		this.right=rSide;
		this.operator=o;
	}

	//----------------------------------------------------------------------------------------

	@Override
	// RETURNS: a boolean value that is true or false, as the function is called on 
	//          an arithmetic expression object,the function returns true
	// EXAMPLE: obj.isArithmetic() = true
	//          where obj is an arithmetic expression object

	public boolean isArithmetic()
	{
		return true;
	}

	//-------------------------------------------------------------------------------------------

	@Override

	// RETURNS: an ArithmeticExp object, the representation of the arithmetic expression
	//          object is returned
	// EXAMPLE: obj.asArithmetic() = obj
	//          obj is an arithmetic expression object


	public ArithmeticExp asArithmetic()
	{
		return this;
	}

	//-----------------------------------------------------------------------------------------------

	// RETURNS: Returns the left subexpression of the arithmetic object which is an expression.
	// EXAMPLE: Exp exp1
	//               = Asts.arithmeticExp (Asts.identifierExp ("n"),
	//                                     "MINUS",
	//                                     Asts.constantExp (Asts.expVal (1)));
	//          exp1.leftOperand() = Asts.identifierExp ("n")

	public Exp leftOperand() {
		return this.left;
	}

	//-----------------------------------------------------------------------------------------------

	// RETURNS: Returns the right subexpression of the arithmetic object which is an expression.
	// EXAMPLE: Exp exp1
	//               = Asts.arithmeticExp (Asts.identifierExp ("n"),
	//                                     "MINUS",
	//                                     Asts.constantExp (Asts.expVal (1)));
	//  exp1.rightOperand() = Asts.constantExp (Asts.expVal (1))

	public Exp rightOperand() {
		return this.right;
	}

	//--------------------------------------------------------------------------------------------------


	// RETURNS: Returns the binary operation as one of the strings
	//     "LT"
	//     "EQ"
	//     "GT"
	//     "PLUS"
	//     "MINUS"
	//     "TIMES"
	// EXAMPLE: Exp exp1
	//               = Asts.arithmeticExp (Asts.identifierExp ("n"),
	//                                     "MINUS",
	//                                     Asts.constantExp (Asts.expVal (1)));
	//  exp1.operation() = MINUS

	public String operation() {
		return this.operator;
	}

	//---------------------------------------------------------------------------------------------------

	@Overidden

	// GIVEN: a Map<String,ExpVal>, which is the environment for a particular definition
	// RETURNS: an ExpVal,after computing based on the operator String on the eleft and 
	//          eright expressions

	public ExpVal value (Map<String,ExpVal> env)
	{
		ExpVal eleft = new ExpVal1();
		ExpVal eright = new ExpVal1();
		ExpVal result = new ExpVal1();


		Long calculatedInteger;
		Boolean calculatedBool;

		try
		{

			eleft = this.left.value(env);
			eright = this.right.value(env);

			if(this.operator.equals("MINUS"))
			{
				
				calculatedInteger = eleft.asInteger() - eright.asInteger();

				result = Asts.expVal(calculatedInteger);

			}

			if(this.operator.equals("LT"))
			{
				if(eleft.asInteger() < eright.asInteger())
				{
					calculatedBool = true;
				}
				else
					calculatedBool = false;

				result = Asts.expVal(calculatedBool);
			}

			if(this.operator.equals("EQ"))
			{

				if(eleft.isInteger() && eright.isInteger())
				{

					if(eleft.asInteger() == eright.asInteger())
					{
						calculatedBool = true;
					}
					else
					{
						calculatedBool = false;
					}
					result = Asts.expVal(calculatedBool);

				}
				else if(eleft.isBoolean() && eright.isBoolean())
				{
					if(eleft.asBoolean() == eright.asBoolean())
					{
						calculatedBool = true;
					}
					else
					{
						calculatedBool = false;
					}
					result = Asts.expVal(calculatedBool);
				}

			}


			if(this.operator.equals("GT"))
			{
				if(eleft.asInteger() > eright.asInteger())
					calculatedBool = true;
				else
					calculatedBool = false;
				result = Asts.expVal(calculatedBool);
			}

			if(this.operator.equals("PLUS"))
			{
				calculatedInteger = eleft.asInteger() + eright.asInteger();
				result = Asts.expVal(calculatedInteger);

			}
			if(this.operator.equals("TIMES"))
			{
				
				calculatedInteger = eleft.asInteger() * eright.asInteger();
				result = Asts.expVal(calculatedInteger);

			}
		}
		catch(NullPointerException n)
		{
			System.out.println("Arithmetic Expression : Warning : Variable of this expression is not a key of the given Map");	
		}
		catch(Exception e1)
		{
			System.out.println("Warning: Exception thrown!");
		}
		return result;
	}

	//--------------------------------------------------------------------------------------------------

}
