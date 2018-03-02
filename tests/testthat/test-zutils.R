context("util fxns: normalize_uri")
test_that("normalize_uri", {
  # prunes trailing slash
  expect_is(normalize_uri("example.com/"), "character")
  expect_match(normalize_uri("example.com/"), "example.com")

  # prunes ports 80 and 443
  expect_match(normalize_uri("example.com:80"), "example.com")
  expect_match(normalize_uri("example.com:443"), "example.com")

  # escapes special characters
  expect_match(normalize_uri("example.com/foo/bar"),
               "example.com/foo%2Fbar")
  expect_match(normalize_uri("example.com/foo+bar"),
               "example.com/foo%2Bbar")
  expect_match(normalize_uri("example.com/foo*bar"),
               "example.com/foo%2Abar")
})


context("util fxns: net_connect_explicit_allowed")
test_that("net_connect_explicit_allowed", {
  aa <- net_connect_explicit_allowed(
    allowed = "example.com",
    uri = "http://example.com")

  expect_is(aa, "logical")
  expect_equal(length(aa), 1)

  # works with lists
  expect_true(
    net_connect_explicit_allowed(
      list("example.com", "foobar.org"),
      "example.com"
    )
  )
  expect_false(
    net_connect_explicit_allowed(
      list("example.com", "foobar.org"),
      "stuff.io"
    )
  )

  # no uri passed, returns FALSE
  expect_false(net_connect_explicit_allowed("google.com"))

  # empty character string uri passed, returns FALSE
  expect_false(net_connect_explicit_allowed("google.com", ""))

  # no allowed passed, errors
  expect_error(net_connect_explicit_allowed(),
               "argument \"allowed\" is missing")
})

context("util fxns: webmockr_net_connect_allowed")
test_that("webmockr_net_connect_allowed", {
  # works with character strings
  expect_false(webmockr_net_connect_allowed("example.com"))
  expect_false(webmockr_net_connect_allowed("http://example.com"))
  expect_false(webmockr_net_connect_allowed("https://example.com"))

  # no uri passed, returns FALSE
  expect_false(webmockr_net_connect_allowed())

  # nonense passed, returns FALSE
  expect_false(webmockr_net_connect_allowed(""))
  expect_false(webmockr_net_connect_allowed("asdfadfafsd"))

  # errors when of wrong class
  expect_error(webmockr_net_connect_allowed(mtcars),
               "uri must be of class character, list")
})

context("util fxns: webmockr_disable_net_connect")
test_that("webmockr_disable_net_connect", {
  # nothing passed
  expect_null(sm(webmockr_disable_net_connect()))
  expect_message(webmockr_disable_net_connect(), "net connect disabled")

  # single uri passed
  expect_message(webmockr_disable_net_connect("google.com"), "net connect disabled")
  expect_is(sm(webmockr_disable_net_connect("google.com")), "character")
  expect_equal(sm(webmockr_disable_net_connect("google.com")), "google.com")

  # many uri's passed
  expect_message(webmockr_disable_net_connect(c("google.com", "nytimes.com")),
                 "net connect disabled")
  expect_is(sm(webmockr_disable_net_connect(c("google.com", "nytimes.com"))),
            "character")
  expect_equal(sm(webmockr_disable_net_connect(c("google.com", "nytimes.com"))),
               c("google.com", "nytimes.com"))

  # errors when of wrong class
  expect_error(webmockr_disable_net_connect(5),
               "allow must be of class character")
  expect_error(webmockr_disable_net_connect(mtcars),
               "allow must be of class character")
})

context("util fxns: webmockr_allow_net_connect")
test_that("webmockr_allow_net_connect", {
  # nothing passed
  expect_true(sm(webmockr_allow_net_connect()))
  expect_message(webmockr_allow_net_connect(), "net connect allowed")

  # check if net collect allowed afterwards, should be TRUE
  expect_true(webmockr_net_connect_allowed())

  # errors when an argument passed
  expect_error(webmockr_allow_net_connect(5), "unused argument")
})

context("util fxns: webmockr_configuration")
test_that("webmockr_configuration", {
  expect_is(webmockr_configuration(), "webmockr_config")
  expect_named(
    webmockr_configuration(),
    c('show_stubbing_instructions', 'show_body_diff', 'query_values_notation',
      'allow', 'net_http_connect_on_start', 'allow_net_connect',
      'allow_localhost')
  )

  # errors when an argument passed
  expect_error(webmockr_configuration(5), "unused argument")
})

context("util fxns: webmockr_configure_reset")
test_that("webmockr_configure_reset", {
  # webmockr_configure_reset does the same thing as webmockr_configure
  expect_identical(webmockr_configure(), webmockr_configure_reset())

  # errors when an argument passed
  expect_error(webmockr_configure_reset(5), "unused argument")
})

context("util fxns: defunct")
test_that("webmockr_disable", {
  expect_error(webmockr_disable(), "see \\?disable")
})
test_that("webmockr_enable", {
  expect_error(webmockr_enable(), "see \\?enable")
})