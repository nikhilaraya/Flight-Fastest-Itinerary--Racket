import java.util.ArrayList;
import java.util.List;


public class UnitTesting {

	public static void main(String[] args) {
		String testArithmetic = "MINUS";
		String testIdentifier = "fact";
		String testDefinition = "factorial";
		Boolean b=true;
		Long t1= (long) 4;
		Long t2= (long) 2;
		ExpVal ev1 = new ExpVal1(b);
		ExpVal ev2 = new ExpVal1(t1);
		ExpVal ev3 = new ExpVal1(t2);
		ConstantExp ce1= new ConstantExp1(ev1);
		ConstantExp ce2= new ConstantExp1(ev2);
		ConstantExp ce3= new ConstantExp1(ev3);
		// Exp e1=new Exp1(ce1);
		// Exp e2=new Exp1(ce2);
		// Exp e3=new Exp1(ce3);
		IdentifierExp ie=new IdentifierExp1(testIdentifier);
		List<String> los = new ArrayList<String>();
		los.add("a");
		los.add("b");
		// LambdaExp le= new LambdaExp1(los,e1);
		// ArithmeticExp ae= new ArithmeticExp1(e2,testArithmetic,e3);
		List<Exp> loe = new ArrayList<Exp>();
		// loe.add(e1);
		
        CallExp ce = new CallExp1(ie,loe);         
		
		List<Def> lod = new ArrayList<Def>();
		
		Ast a1= new Ast1(lod);
		
		
		Exp exp1= Asts.arithmeticExp (Asts.identifierExp ("n"),"MINUS",Asts.constantExp (Asts.expVal(1)));
        Exp call1= Asts.callExp (Asts.identifierExp ("fact"),Asts.list (exp1));
        Exp testPart= Asts.arithmeticExp (Asts.identifierExp ("n"),"EQ",Asts.constantExp (Asts.expVal(0)));
        Exp thenPart= Asts.constantExp (Asts.expVal (1));
        Exp elsePart= Asts.arithmeticExp (Asts.identifierExp ("n"),"TIMES",call1);
        Def def1= Asts.def ("fact",Asts.lambdaExp (Asts.list ("n"),Asts.ifExp (testPart,thenPart,elsePart)));
        ExpVal result = Programs.run (Asts.list (def1),Asts.list (Asts.expVal (5)));
		
		assert ev1.isBoolean() == true : "incorrect for isBoolean()";
		assert ev2.isInteger() == true : "incorrect for isInteger()";
		assert ev1.asBoolean() == b : "incorrect for asBoolean()";
		assert ev2.asInteger() == t1 : "incorrect for asInteger()";
		assert ce1.value() == ev1 : "incorrect for constantExp.value()";
		assert ce1.isConstant() == true : "incorrect for constantExp.isConstant()";
		assert ce1.asConstant() == ce1 : "incorrect for constantExp.asConstant()";
		assert ie.name() == testIdentifier : "incorrect for identifierExp.name()";
		assert ie.isIdentifier() == true : "incorrect for identifierExp.isIdentifier()";
		assert ie.asIdentifier() == ie : "incorrect for identifierExp.asIdentifier()";
	    assert ce.arguments() == loe : "incorrect for callExp.arguments()";
	    assert ce.operator() == ie : "incorrect for callExp.operator()";
	    assert ce.isCall() == true : "incorrect for callExp.isCall()";
	    assert ce.asCall() == ce : "incorrect for callExp.asCall()";
	    assert a1.isPgm() == true : "incorrect for a.isPgm()";
	    assert a1.asPgm() == a1 : "incorrect for a1.asPgm()";
	    assert Programs.run (Asts.list (def1),Asts.list (Asts.expVal (4))).asInteger() == 24 : "incorrect for Programs.run()";
		System.out.println("All test passed");
		
		
	}

}
