#!/usr/bin/env bash
set -euo pipefail

# Deploy Preview CLI
# Requires: VERCEL_TOKEN, vercel CLI, curl, jq
# Optional: VERCEL_SCOPE (team slug)

VERCEL_API="https://api.vercel.com"

if [[ -z "${VERCEL_TOKEN:-}" ]]; then
  echo "Error: VERCEL_TOKEN not set" >&2
  exit 1
fi

SCOPE_FLAG="${VERCEL_SCOPE:+--scope $VERCEL_SCOPE}"

cmd="${1:-help}"
shift || true

case "$cmd" in
  deploy)
    # deploy [path] [--prod]
    DIR="${1:-.}"
    EXTRA="${2:-}"
    URL=$(cd "$DIR" && vercel --yes --token "$VERCEL_TOKEN" $SCOPE_FLAG $EXTRA 2>/dev/null)
    echo "$URL"
    ;;

  deploy-branch)
    # deploy-branch <repo-path> <branch>
    REPO="${1:-.}"
    BRANCH="${2:-}"
    if [[ -z "$BRANCH" ]]; then
      echo "Usage: deploy-preview.sh deploy-branch <path> <branch>" >&2
      exit 1
    fi
    (cd "$REPO" && git checkout "$BRANCH" && git pull)
    URL=$(cd "$REPO" && vercel --yes --token "$VERCEL_TOKEN" $SCOPE_FLAG 2>/dev/null)
    echo "$URL"
    ;;

  status)
    # status <url-or-id>
    DEPLOY_ID="${1:-}"
    if [[ -z "$DEPLOY_ID" ]]; then
      echo "Usage: deploy-preview.sh status <url-or-id>" >&2
      exit 1
    fi
    curl -s -H "Authorization: Bearer $VERCEL_TOKEN" \
      "$VERCEL_API/v13/deployments/$DEPLOY_ID" | \
      jq '{id:.id, url:.url, state:.readyState, created:.createdAt, inspector:.inspectorUrl}'
    ;;

  logs)
    # logs <url-or-id>
    DEPLOY_ID="${1:-}"
    if [[ -z "$DEPLOY_ID" ]]; then
      echo "Usage: deploy-preview.sh logs <url-or-id>" >&2
      exit 1
    fi
    vercel inspect "$DEPLOY_ID" --logs --wait --token "$VERCEL_TOKEN" $SCOPE_FLAG 2>&1 | tail -50
    ;;

  audit)
    # audit <preview-url>
    URL="${1:-}"
    if [[ -z "$URL" ]]; then
      echo "Usage: deploy-preview.sh audit <preview-url>" >&2
      exit 1
    fi
    [[ "$URL" != https://* ]] && URL="https://$URL"
    RESULT=$(curl -s "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=${URL}&category=performance&category=accessibility&category=best-practices&category=seo")
    echo "$RESULT" | jq '{
      performance: .lighthouseResult.categories.performance.score,
      accessibility: .lighthouseResult.categories.accessibility.score,
      bestPractices: .lighthouseResult.categories["best-practices"].score,
      seo: .lighthouseResult.categories.seo.score,
      fcp: .lighthouseResult.audits["first-contentful-paint"].displayValue,
      lcp: .lighthouseResult.audits["largest-contentful-paint"].displayValue,
      cls: .lighthouseResult.audits["cumulative-layout-shift"].displayValue,
      tbt: .lighthouseResult.audits["total-blocking-time"].displayValue
    }'
    ;;

  list)
    # list [project-id]
    PROJECT="${1:-}"
    curl -s -H "Authorization: Bearer $VERCEL_TOKEN" \
      "$VERCEL_API/v6/deployments?limit=5${PROJECT:+&projectId=$PROJECT}" | \
      jq '.deployments[] | {url:.url, state:.readyState, created:.createdAt, branch:.meta.githubCommitRef}'
    ;;

  help|*)
    echo "Deploy Preview — Vercel deployment management"
    echo ""
    echo "Commands:"
    echo "  deploy [path] [--prod]       Deploy preview (or production)"
    echo "  deploy-branch <path> <br>    Checkout branch and deploy"
    echo "  status <url-or-id>           Check deployment status"
    echo "  logs <url-or-id>             View build logs"
    echo "  audit <preview-url>          Run Lighthouse audit"
    echo "  list [project-id]            Recent deployments"
    ;;
esac
