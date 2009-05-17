module Php2Rb
  Program = com.caucho.quercus.program
  Expr = com.caucho.quercus.expr

  {
    Program::Function => [:statement],
    Program::ReturnStatement => [:expr],
    Program::ClassDefStatement => [:cl],
    Program::EchoStatement => [:expr],
    Program::TextStatement => [:value],
    Program::ForeachStatement => [:obj_expr, :block, :value],
    Expr::BinaryExpr => [:left, :right],
    Expr::AssignExpr => [:var, :value],
    Expr::AssignRefExpr => [:var, :value],
    Expr::StaticMethodExpr => [:class_name, :method_name, :fun, :args],
    Expr::StringLiteralExpr => [:value], 
    Expr::FunctionExpr => [:args],
    Expr::ArrayFunExpr => [:keys, :values],
    Expr::ArrayGetExpr => [:expr, :index],
    Expr::MethodCallExpr => [:obj_expr, :args],
    Expr::ThisFieldExpr => [:name],
    Expr::UnaryExpr => [:expr]
  }.each do |klass, keys|
    klass.instance_eval do
      keys.each do |key|
        java_key = key.to_s.camel_case
        java_key = java_key[0..0].downcase + java_key[1..-1]
        field_reader :"_#{java_key}" => key
      end
    end
  end

end
