resource "aws_apigatewayv2_api" "Project3_api_gateway" {
  name        = "Project3-API-Gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "Project3_stage" {
  api_id = aws_apigatewayv2_api.Project3_api_gateway.id
  name   = "api-call"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.Project3_log_group_api_gw.arn
    format          = jsonencode({
      requestId = "$context.requestId",
      sourceIp       = "$context.identity.sourceIp",
      requestTime = "$context.requestTime",
      protocol = "$context.protocol",
      httpMethod = "$context.httpMethod",
      resourcePath     = "$context.resourcePath",
      routeKey = "$context.routeKey",
      integrationErrorMessage = "$context.integrationErrorMessage",
      status   = "$context.status",
      responseLength = "$context.responseLength"
    })
  }
}

resource "aws_cloudwatch_log_group" "Project3_log_group_api_gw" {
  name              = "/aws/api-gw/${aws_apigatewayv2_api.Project3_api_gateway.name}"
  retention_in_days = 14
}

resource "aws_apigatewayv2_integration" "Project3_integration" {
  api_id = aws_apigatewayv2_api.Project3_api_gateway.id
  integration_type = "AWS_PROXY"
  integration_uri = aws_lambda_function.lambda_function.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "Project3_route_get" {
  api_id = aws_apigatewayv2_api.Project3_api_gateway.id
  route_key = "GET /severless-lambda-function1"
  target = "integrations/${aws_apigatewayv2_integration.Project3_integration.id}"
}

resource "aws_apigatewayv2_route" "Project3_route_post" {
  api_id = aws_apigatewayv2_api.Project3_api_gateway.id
  route_key = "POST /severless-lambda-function1"
  target = "integrations/${aws_apigatewayv2_integration.Project3_integration.id}"
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id = "AllowExecutionFromAPIGateway"
  action       = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal    = "apigateway.amazonaws.com"

  # The source ARN is the API Gateway ARN
  source_arn = "${aws_apigatewayv2_api.Project3_api_gateway.execution_arn}/*/*"
}

output "api_gateway_url" {
  value = aws_apigatewayv2_stage.Project3_stage.invoke_url
}

