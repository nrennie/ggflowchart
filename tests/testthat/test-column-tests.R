test_that("Single column fails", {
  expect_error(ggflowchart(data = data.frame(from = c(1, 2, 3))))
})
