#!/bin/bash

# SARA AI Server Test Script
# Tests the SARA server endpoints and verifies integration

echo "🧪 SARA AI Server Integration Test"
echo "=================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Health Check
echo "📊 Test 1: Health Check Endpoint"
echo "GET https://ai.saraagent.com/api/health"
echo ""

HEALTH_RESPONSE=$(curl -s -w "\n%{http_code}" https://ai.saraagent.com/api/health)
HTTP_CODE=$(echo "$HEALTH_RESPONSE" | tail -n1)
RESPONSE_BODY=$(echo "$HEALTH_RESPONSE" | head -n-1)

if [ "$HTTP_CODE" -eq 200 ]; then
    echo -e "${GREEN}✅ Health check passed${NC}"
    echo "Response: $RESPONSE_BODY"
else
    echo -e "${RED}❌ Health check failed (HTTP $HTTP_CODE)${NC}"
    echo "Response: $RESPONSE_BODY"
fi

echo ""
echo "---"
echo ""

# Test 2: Fast Mode Chat
echo "📱 Test 2: Fast Mode Chat (llama3.2:3b)"
echo "POST https://ai.saraagent.com/api/chat"
echo "Message: 'مرحبا'"
echo ""

FAST_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST https://ai.saraagent.com/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message":"مرحبا","use_najdi":false,"model":"fast"}')

HTTP_CODE=$(echo "$FAST_RESPONSE" | tail -n 1)
RESPONSE_BODY=$(echo "$FAST_RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 200 ]; then
    echo -e "${GREEN}✅ Fast mode test passed${NC}"
    echo "Response (first 200 chars):"
    echo "$RESPONSE_BODY" | head -c 200
    echo "..."
else
    echo -e "${RED}❌ Fast mode test failed (HTTP $HTTP_CODE)${NC}"
    echo "Response: $RESPONSE_BODY"
fi

echo ""
echo "---"
echo ""

# Test 3: Accurate Mode Chat
echo "🎯 Test 3: Accurate Mode Chat (ALLaM-7B)"
echo "POST https://ai.saraagent.com/api/chat"
echo "Message: 'اشرح لي كيف أجدد جوازي بالتفصيل'"
echo ""

ACCURATE_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST https://ai.saraagent.com/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message":"اشرح لي كيف أجدد جوازي بالتفصيل","use_najdi":false,"model":"accurate"}')

HTTP_CODE=$(echo "$ACCURATE_RESPONSE" | tail -n 1)
RESPONSE_BODY=$(echo "$ACCURATE_RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 200 ]; then
    echo -e "${GREEN}✅ Accurate mode test passed${NC}"
    echo "Response (first 200 chars):"
    echo "$RESPONSE_BODY" | head -c 200
    echo "..."
else
    echo -e "${RED}❌ Accurate mode test failed (HTTP $HTTP_CODE)${NC}"
    echo "Response: $RESPONSE_BODY"
fi

echo ""
echo "---"
echo ""

# Test 4: Najdi Dialect
echo "🗣️  Test 4: Najdi Dialect"
echo "POST https://ai.saraagent.com/api/chat"
echo "Message: 'وش الأخبار؟'"
echo ""

NAJDI_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST https://ai.saraagent.com/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message":"وش الأخبار؟","use_najdi":true,"model":"fast"}')

HTTP_CODE=$(echo "$NAJDI_RESPONSE" | tail -n1)
RESPONSE_BODY=$(echo "$NAJDI_RESPONSE" | head -n-1)

if [ "$HTTP_CODE" -eq 200 ]; then
    echo -e "${GREEN}✅ Najdi dialect test passed${NC}"
    echo "Response: $RESPONSE_BODY" | head -c 200
    echo "..."
else
    echo -e "${RED}❌ Najdi dialect test failed (HTTP $HTTP_CODE)${NC}"
    echo "Response: $RESPONSE_BODY"
fi

echo ""
echo "=================================="
echo "🎉 Test Suite Complete!"
echo ""

# Overall result
if [ "$HTTP_CODE" -eq 200 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    echo "SARA AI server is working correctly."
    echo ""
    echo "Next steps:"
    echo "  1. Run 'flutter run' to test in app"
    echo "  2. Check server status indicator in ChatScreen"
    echo "  3. Test voice-to-voice calling"
    echo "  4. Monitor response times"
    exit 0
else
    echo -e "${RED}❌ Some tests failed${NC}"
    echo "Please check SARA server status."
    exit 1
fi
