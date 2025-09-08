# Test file for main MvGGE functions

test_that("test_MvGGE works for continuous phenotypes", {
  set.seed(123)
  data <- simulate_data(n = 100, maf = 0.3, f = 0.2)
  
  result <- test_MvGGE(data$Y1, data$Y2, data$G, data$E)
  
  expect_s3_class(result, "MvGGE_result")
  expect_equal(result$analysis_type, "Continuous Bivariate (MANOVA)")
  expect_true(!is.na(result$results$statistic))
  expect_true(!is.na(result$results$p_value))
  expect_equal(result$results$method, "MANOVA")
})

test_that("test_MvGGE works for binary phenotypes", {
  set.seed(123) 
  data <- simulate_data(n = 100, maf = 0.3, f = 0.2)
  
  result <- test_MvGGE(data$Yb1, data$Yb2, data$G, data$E)
  
  expect_s3_class(result, "MvGGE_result")
  expect_equal(result$analysis_type, "Binary Bivariate (GEE)")
  expect_equal(result$results$method, "GEE-Binary")
})

test_that("test_MvGGE works for mixed phenotypes", {
  set.seed(123)
  data <- simulate_data(n = 100, maf = 0.3, f = 0.2)
  
  result <- test_MvGGE(data$Y1, data$Yb2, data$G, data$E)
  
  expect_s3_class(result, "MvGGE_result")  
  expect_equal(result$analysis_type, "Mixed (Y1 Continuous, Y2 Binary)")
  expect_equal(result$results$method, "GEE-Mixed")
})

test_that("test_MvGGE handles swapped mixed phenotypes", {
  set.seed(123)
  data <- simulate_data(n = 100, maf = 0.3, f = 0.2)
  
  result <- test_MvGGE(data$Yb1, data$Y2, data$G, data$E)
  
  expect_s3_class(result, "MvGGE_result")
  expect_equal(result$analysis_type, "Mixed (Y1 Binary, Y2 Continuous)")
  expect_true(!is.null(result$results$note))
})

test_that("Configuration object works", {
  config <- MvGGE_config(max_iterations = 50, verbose = TRUE)
  
  expect_s3_class(config, "MvGGE_config")
  expect_equal(config$max_iterations, 50)
  expect_true(config$verbose)
})

test_that("Error handling works for invalid inputs", {
  expect_error(test_MvGGE(c(1,2,3), c(1,2), c(0,1,2), c(0,1,0)), 
               "same length")
  expect_error(test_MvGGE(c(1,2,3), c(1,2,3), c(0,1,3), c(0,1,0)),
               "0, 1, or 2")
})