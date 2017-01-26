require 'test_helper'

class EventStoriesTest < ActionDispatch::IntegrationTest

  setup do
    @user_first = User.create! email: "first@user.com", password: "password"
    @user_second = User.create! email: "second@user.com", password: "password"
    @event_params = { name: "Some event", time: Time.now+7.days, place: "Some place", purpose: "Some purpose" }
    @user_first.events.create!  name: "User first event",
                                time: Time.now+7.days,
                                place: "Some place",
                                purpose: "Some purpose",
                                owner_id: @user_first.id
    @user_second.events.create! name: "User second event",
                                time: Time.now+7.days,
                                place: "Some place",
                                purpose: "Some purpose",
                                owner_id: @user_second.id
    @image_base64 = "data:image/png;base64,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6Zw4BgFJ0kw8cJfgbJtviYAkWS5qWi8gSSQCkkQiEZAkEgFJIhGQJBIBSSKRCEgSiYAkkQhIEomAJJFIBCSJRECSSAQkiURAkkgkApJkd2Wnu8MKSJJtQZGAJJFMgCIBSSLZaxQJSBIBSUCqk2uvvfbqq2/U8O2666676qqr/v3vTLeD//3vf3aynVC44D//+U97+tUHxS5+zTXX+GO/pv03e+WlYi99/fXX2+95oyUd8TQDFM0fSH/9618f+9jHPvrRj/Y/TcW///3vP/nJT37AAx7w5je/+U9/+lM4/2c/+9mDHvSgo48+unDN7373uy996Utfe1Be+cpXHnvssf745S9/+XnnnfepT33qpz/9af0dGnj++9//2oN//OMfdktXXHGFgCQgbZf861//euc733nHO97xIQ95iB/59re/fe973/v/Dso97nGPJz7xiWZScP5ll132whe+8OY3v/lzn/vcwmVN46+88sqrDspJJ530pS99yR/bQQPqu971rtNPP73+Jt/61rfa6zqiDJP+WEASkLZIfvzjHx9yyCG3v/3tH/7whzuuXve6193vfvczk3LppZe+6EUveuADH/iLX/wCntWHP/zhu971rre5zW1e8IIXVL7ERz7ykW9961t85D3vec9PfvITA5uji101dyndCfQj9uBVr3qV2TH3J9kimcfoV2CoB8HVDIR+5D//+Y+9TXtRf67dRvaJBng8F46oOaX2RHu6rwj2px/0Px3q4f59WcFbc9NaD6QhdAlIWyS2tJsD9rSnPe1Od7rTwx72MHfzjjzyyEc84hH+fX/5y1++5z3v+YEPfMDP/+Uvf2nmyE641a1uVQ8kw943vvENPvLe977XLNIXvvCFl73sZa94xSvOOussU24P1d73vveZ+2dO4Gte85o///nPdhvvfve7n//855shev3rX2/66jGSicHpjW9846tf/Wr7l5ks+1d4Xbumwc9OcJfyQx/6kCv0r371K3tH9qJ20G7gs5/9rOMhGOrvfe977p3a7+985zt2xI5/5jOfsce2LtjncO65537uc5/74Q9/aJ/SUUcdZX/a9T/2sY/5/dtd/e53v/OP0Wz+2WefbW/NvNxWcyogbbuYLlqscsQRR5ge3OUudzn88MPt4G9/+9s73OEOj3zkI/2cH/zgB4aZpzzlKb7umoo89alPNS282c1uNgZIH/zgB5/3vOcZLK88KKZn9rp2/P3vf/+ZZ55pdubag/KWt7zloosusj9NLw0SbLvs4Bve8AaDvZ1mx//4xz8a3gKBYQfN9Lm9MjG7an/a8d/85jfPeMYzPvGJT/irGzDMZoZ7thu2D8fvxH4bfr72ta85kJ75zGcaeP7+97/by9lbe/azn21Bo/958skn/+hHP3Kf1n6//e1vt9u2Z9kS8OIXv/gPf/iDHSxYJAFpJ8W+V0PFO97xjgsuuABA+vWvf33rW98aQDrttNNucYtbPOEJT7DHxkA8/vGPNw2z9fgmN7mJeX1jLJJFYlAp89bMSjg83Bpcd1AMP051mCIaZvgK5js5kOCw+XODRXJq0a9m9Ia9kP1piLIHeKK9RwcYy1e+8hW7bTvHnmi/7fHnP/95O24GxwwpEGtG5pRTTsEbMcP485//HBcxg2mGyB6ccMIJtkBMGzgJSFshZl7saz7ssMPMFNh3fOc73/mhD32o6WJqkW55y1s+/elPN2Wy33b88ssvt6X6pje96bOe9awyA14AksdIzCVAz+yFjJwwf89cO8OqxWl28Pjjj7/kkkuCObU7MYDZu7AHhRjJbIKFWIZJswlGctgR03WzgTjB3qNZkvCsU0891fzJ194g5rmZp2fHP/rRj37zm9/EafZEs07401Yls07488QTTzznnHMcSGYeBaQZAuniiy82as7wY0yDsXN3v/vd7fHjHvc48+Dtt8VI7kR5jGSLsYU0t7vd7e52t7vd9773tSfa+Ya3Y445phtI5gKlQLIYw4yVWUVzgQwbhh+3SCmQYJfsuLEjprKpRTJDYXpsr2VXszPPOOMMeyEHkml8GUhf/epX7bavukHsZtzsGJDMBDGQ7Ok1QPr9738vIM0TSEbNOYruc5/7GM1tQHrMYx5j7pAt84ceeqgtwOY42UpsrN35559v6mLnGIrsfADpJS95iRs3swnwlMYAyYIK9/H8sgyk4NoZzmGFzDBeeOGFb3rTm5wPgJju2kEQCU1AshXEDC9j0i9eBlLBtROQ5gkk0wyLj684KLaImrV58IMf7MkNFgIZVA45KAYeC5BMUy0quOIGsdD8wIEDFq+7a2e6ZYTEcccdN/RaRi18/etf5yPmWbFHZCu34+dtb3ubIcpzIAxsz3nOc/7yl7/YcXOujAGzgyAbDEV2Efuvc+KGN9PaFEh2ZWcjjFIzns2Auji4oeyIcrHYz8xgSjZ88pOfBJFtcZEz+LYoOOuAYM+ezriyBQLPsrdjt+0LgS1GfH2znynrIPp7t8W08F73utejHvUo/9MwY+boSU960v3vf39TRFvsw/m2JN/2trc1Bs//NCBZHFUAkmmkhRx8xHg/zmwwzDhrZ2bNiDunj03zzG4Ya+dIM57aTCU2ZwxRZqOY/g4pTr5YGKFiJ9gFP/7xjxtJ6IAx0LIJMtU3eJTpb6NGnDr/9Kc/bY/Z2LJpTelvp/UNUcbo4DT7hI1j/Nvf/iYgzc06mZ3hDURf8rHJmCqZhVLwrMx3sj8LxIOdEGyFKRxf2f50hXM/zeljf6Iv277LGbZuPUZyojkNkCB+gnueDgZ7Ld6EtTvJ7snacRDZvCHL7yW8Eb9VPIsPBvtTb5EWymyQSCYJhwQkiWRKgAlIEomwJCBJBCQBSSIsCUgSScSSgCSRTIAlAUki2WsRkCQSAUkiEZAkEgFJIpEISBKJgCSRCEgSiYAkkUgEJIlEQJJIBCSJRECSSCQCkkQiIEkkApJEIiBJJBIBSSIRkCQSAUkiEZAkEomAJJEISBKJgCSRCEgSiWSM/D/Wk5WIXUyKKAAAAABJRU5ErkJggg=="
  end

  test "shold get events for first user" do
    get events_path, params: { auth_token: @user_first.auth_token }
    assert_response :success
    assert_equal @user_first.events.map(&:id), JSON.parse(response.body).map{|x| x["id"]}
  end

  test "shold get events for second user" do
    get events_path, params: { auth_token: @user_second.auth_token }
    assert_response :success

    assert_equal @user_second.events.map(&:id), JSON.parse(response.body).map{|x| x["id"]}
  end

  test "shold show event" do
    get event_path(@user_first.events.first.id), params: { auth_token: @user_first.auth_token }
    assert_response :success
    assert_equal @user_first.events.first.id, JSON.parse(response.body)["id"]
  end

  test "shold not show event" do
    get event_path(@user_first.events.first.id), params: { auth_token: @user_second.auth_token }
    assert_response 403
  end

  test "should create event" do
    assert_difference '@user_first.events.count' do
      post events_path, params: { auth_token: @user_first.auth_token, event: @event_params }
      assert_response :success
    end
  end

  test "should update event" do
    new_time = Time.now + 1.day
    put event_path (@user_first.events.first.id), params: { auth_token: @user_first.auth_token, event: { time: new_time }}
    assert_response :success
    assert_equal @user_first.events.first.time, JSON.parse(response.body)["time"]
  end

  test "should not update event" do
    new_time = Time.now + 1.day
    put event_path (@user_first.events.first.id), params: { auth_token: @user_second.auth_token, event: { time: new_time }}
    assert_response 403
  end

  test "should destroy event" do
    assert_difference '@user_first.events.count', -1 do
      delete event_path (@user_first.events.first.id), params: { auth_token: @user_first.auth_token }
      assert_response :success
    end
  end

  test "should not destroy event" do
    delete event_path (@user_first.events.first.id), params: { auth_token: @user_second.auth_token }
    assert_response 403
  end

  test "should attach file" do
    put event_path (@user_first.events.first.id), params: { auth_token: @user_first.auth_token, event: { attachment: @image_base64 }}
    assert_response :success
    assert_equal @user_first.events.first.attachment.url, JSON.parse(response.body)["attachment"]["url"]
  end

  test "should get event in a scope of set interval " do
    set_interval = 1
    get events_path, params: { auth_token: @user_first.auth_token, interval: set_interval.to_s}
    assert_response :success
    assert_equal @user_first.events.with_interval(set_interval).map(&:id), JSON.parse(response.body).map{|x| x["id"]}
  end
end
