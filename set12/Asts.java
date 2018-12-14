import java.util.ArrayList;
import java.util.List;
import java.util.Map;

//Asts class defines public static methods for running any given program of the language on any given inputs.

public class Asts {
	
	// Static factory methods for Def 
	// GIVEN: a String and an Exp object, the string refers to the definition name
	//        and the expression is the definition body
	// RETURNS: a Def with the given left and right hand sides.
    public static Def def (String id1, Exp rhs) { 
    	 return new Def1(id1,rhs);
    }
    
    //----------------------------------------------------------------------------------------
    
    // Static factory methods for Exp
    // GIVEN: an Exp,a String and an Exp,the two expression objects specify the 
    //        left and right hand side of the arithematic expression and the 
    //        string specifies the operation of the expression
    // RETURNS: an ArithmeticExp representing e1 op e2.   
    public static ArithmeticExp arithmeticExp (Exp e1, String op, Exp e2) { 
    	return new ArithmeticExp1(e1,op,e2);
    }
    
    //-----------------------------------------------------------------------------------------
    
    // GIVEN: an Exp object and a list of Exp objects.The Exp object specifies the
    //        operator and the list of expressions specify the operands
    // RETURNS: a CallExp with the given operator and operand expressions.

    
    public static CallExp callExp (Exp operator, List<Exp> operands) { 
    	return new CallExp1(operator,operands);
    }
    
    //-----------------------------------------------------------------------------------------
    
    // GIVEN: an ExpVal, which is either a boolean or long or a FunVal object
    // RETURNS: a ConstantExp with the given value.

    
    public static ConstantExp constantExp (ExpVal value) { 
    	return new ConstantExp1(value);
    }
    
    //---------------------------------------------------------------------------------------
    
    // GIVEN: a String which specifies the Identifier name
    // RETURNS: an IdentifierExp with the given identifier name.

    
    public static IdentifierExp identifierExp (String id) {
    	return new IdentifierExp1(id);
    }
    
    //-----------------------------------------------------------------------------------------
    
    // GIVEN: three Exp objects, each object specifying the test part,
    //        then part and the else part of an IfExp
    // RETURNS: an IfExp with the given components.

    
    public static IfExp ifExp (Exp testPart, Exp thenPart, Exp elsePart) { 
    	return new IfExp1(testPart,thenPart,elsePart);
    }
    
    //------------------------------------------------------------------------------------------
    
    // GIVEN: a list of strings and an expression, the list of strings 
    //        specify the formals of a lambda expression and the expression 
    //        specifies the body of the lambda expression
    // RETURNS: a LambdaExp with the given formals and body.
 
    
    public static LambdaExp lambdaExp (List<String> formals, Exp body) {  
    	return new LambdaExp1(formals,body);
    }
    
    //----------------------------------------------------------------------------------------
    
    // Static factory methods for ExpVal
    
    // GIVEN: a boolean value,that is, either true or false
    // RETURNS: a value encapsulating the given boolean.

    
    public static ExpVal expVal (boolean b) { 
    	return new ExpVal1(b);
    }
    
    //-----------------------------------------------------------------------------------------
    
    // GIVEN: a long value
    // RETURNS: a value encapsulating the given (long) integer.

    
    public static ExpVal expVal (long n) { 
    	
    	return new ExpVal1(n);
    }
    
    //------------------------------------------------------------------------------------------
    
    // GIVEN: a lambda expression object and a Map<String,ExpVal> which 
    //        specifies the environment
    // RETURNS: a value encapsulating the given lambda expression
    //          and environment.

    
    public static FunVal expVal (LambdaExp exp, Map<String,ExpVal> env) {
    	return new FunVal1(exp,env);
    }
    
    //-----------------------------------------------------------------------------------------------
    
    // Static methods for creating short lists
    // GIVEN: an element of X type
    // RETURNS: a list of X with the given element added into the list
    
    public static <X> List<X> list (X x1) { 
    	
    	List<X> l=new ArrayList<X>();
    	l.add(x1);
    	return l;
    }
    
    //--------------------------------------------------------------------------------------------------
    
    // GIVEN: two elements of X type
    // RETURNS: a list of X with the given elements added into the list

    
    public static <X> List<X> list (X x1, X x2) { 
    	List<X> l=new ArrayList<X>();
    	l.add(x1);
    	l.add(x2);
    	return l;
    }
    
    //-----------------------------------------------------------------------------------------------
    
    // GIVEN: three elements of X type
    // RETURNS: a list of X with the given elements added into the list
 
    
    public static <X> List<X> list (X x1, X x2, X x3) {
    	List<X> l=new ArrayList<X>();
    	l.add(x1);
    	l.add(x2);
    	l.add(x3);
    	return l;
    }
    
    //---------------------------------------------------------------------------------------------------
    
    // GIVEN: four elements of X type
    // RETURNS: a list of X with the given elements added into the list

    
    public static <X> List<X> list (X x1, X x2, X x3, X x4) {
    	List<X> l=new ArrayList<X>();
    	l.add(x1);
    	l.add(x2);
    	l.add(x3);
    	l.add(x4);
    	return l;
    }
    
    //--------------------------------------------------------------------------------------------------
}
